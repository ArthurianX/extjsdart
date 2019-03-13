import 'dart:convert';

import 'package:source_span/source_span.dart';
import 'package:angular/src/compiler/analyzed_class.dart';
import 'package:angular/src/compiler/view_compiler/expression_converter.dart';
import 'package:angular/src/core/change_detection/change_detection.dart'
    show ChangeDetectionStrategy, ChangeDetectorState;
import 'package:angular/src/core/linker/view_type.dart' show ViewType;
import "package:angular/src/core/metadata/view.dart" show ViewEncapsulation;
import 'package:angular/src/source_gen/common/names.dart'
    show toTemplateExtension;
import 'package:angular_compiler/cli.dart';

import '../compile_metadata.dart'
    show
        CompileDirectiveMetadata,
        CompileIdentifierMetadata,
        CompileTokenMetadata,
        CompilePipeMetadata,
        CompileQueryMetadata,
        CompileTokenMap,
        CompileTypeMetadata,
        CompileTypedMetadata;
import '../compiler_utils.dart';
import '../i18n/message.dart';
import '../identifiers.dart';
import '../output/output_ast.dart' as o;
import '../template_ast.dart'
    show
        AttrAst,
        BoundTextAst,
        ElementAst,
        EmbeddedTemplateAst,
        NgContentAst,
        ProviderAst,
        ProviderAstType,
        ReferenceAst,
        TemplateAst,
        VariableAst;
import 'compile_element.dart' show CompileElement, CompileNode;
import 'compile_method.dart' show CompileMethod;
import 'compile_pipe.dart' show CompilePipe;
import 'compile_query.dart' show CompileQuery, addQueryToTokenMap;
import 'constants.dart'
    show
        parentRenderNodeVar,
        appViewRootElementName,
        DetectChangesVars,
        ViewProperties,
        InjectMethodVars;
import 'ir/providers_node.dart';
import 'ir/view_storage.dart';
import 'perf_profiler.dart';
import 'view_compiler_utils.dart'
    show
        astAttribListToMap,
        createDiTokenExpression,
        createSetAttributeStatement,
        cachedParentIndexVarName,
        getViewFactory,
        getViewFactoryName,
        identifierFromTagName,
        injectFromViewParentInjector,
        mergeHtmlAndDirectiveAttrs;
import 'view_name_resolver.dart';

/// Visibility of NodeReference within AppView implementation.
enum NodeReferenceVisibility {
  classPublic, // Visible across build and change detectors or other closures.
  build, // Only visible inside DOM build process.
}

final notThrowOnChanges = o.not(o.importExpr(Identifiers.throwOnChanges));

/// Reference to html node created during AppView build.
class NodeReference {
  final CompileElement parent;
  final int nodeIndex;
  final String _name;

  NodeReferenceVisibility _visibility = NodeReferenceVisibility.classPublic;

  NodeReference(this.parent, this.nodeIndex) : _name = '_el_$nodeIndex';
  NodeReference.html(this.parent, this.nodeIndex) : _name = '_html_$nodeIndex';
  NodeReference.inlinedNode(this.parent, this.nodeIndex, int inlinedNodeIndex)
      : _name = '_el_${nodeIndex}_$inlinedNodeIndex';
  NodeReference.textNode(this.parent, this.nodeIndex)
      : _name = '_text_$nodeIndex';
  NodeReference.inlinedTextNode(
      this.parent, this.nodeIndex, int inlinedNodeIndex)
      : _name = '_text_${nodeIndex}_$inlinedNodeIndex';
  NodeReference.anchor(this.parent, this.nodeIndex,
      [this._visibility = NodeReferenceVisibility.build])
      : _name = '_anchor_$nodeIndex';
  NodeReference.appViewRoot()
      : parent = null,
        nodeIndex = -1,
        _name = appViewRootElementName;

  void lockVisibility(NodeReferenceVisibility visibility) {
    if (_visibility != NodeReferenceVisibility.classPublic &&
        _visibility != visibility) {
      throw ArgumentError('The reference was already restricted. '
          'Can\'t change access to reference.');
    }
    _visibility = visibility;
  }

  o.Expression toReadExpr() {
    return _visibility == NodeReferenceVisibility.classPublic
        ? o.ReadClassMemberExpr(_name)
        : o.variable(_name);
  }

  o.Expression toWriteExpr(o.Expression value) {
    return _visibility == NodeReferenceVisibility.classPublic
        ? o.WriteClassMemberExpr(_name, value)
        : o.variable(_name).set(value);
  }
}

/// Reference to html node created during AppView build.
class AppViewReference {
  final CompileElement parent;
  final int nodeIndex;
  final String _name;

  AppViewReference(this.parent, this.nodeIndex)
      : _name = '_compView_$nodeIndex';

  o.Expression toReadExpr() {
    return o.ReadClassMemberExpr(_name);
  }

  o.Expression toWriteExpr(o.Expression value) {
    return o.WriteClassMemberExpr(_name, value);
  }
}

/// Interface to generate a build function for an AppView.
abstract class AppViewBuilder {
  /// Creates an HTML document fragment from trusted [html].
  ///
  /// The [html] argument may be any expression that evaluates to a string
  /// containing **trusted** HTML.
  NodeReference createHtml(
    CompileElement parent,
    int nodeIndex,
    o.Expression html,
  );

  /// Creates an unbound literal text node.
  NodeReference createTextNode(
      CompileElement parent, int nodeIndex, o.Expression text, TemplateAst ast);

  NodeReference createBoundTextNode(
      CompileElement parent, int nodeIndex, BoundTextAst ast);

  /// Create an html node and appends to parent element.
  void createElement(CompileElement parent, NodeReference elementRef,
      int nodeIndex, String tagName, TemplateAst ast);

  /// Creates an html node with a namespace and appends to parent element.
  void createElementNs(CompileElement parent, NodeReference elementRef,
      int nodeIndex, String ns, String tagName, TemplateAst ast);

  /// Create a view container for a given node reference and index.
  ///
  /// isPrivate indicates that the view container is only used for an embedded
  /// view and is not publicly shared through injection or view query.
  o.Expression createViewContainer(
      NodeReference nodeReference, int nodeIndex, bool isPrivate,
      [int parentNodeIndex]);

  /// Locally caches node reference for component and appends to parent
  /// html node.
  AppViewReference createComponentNodeAndAppend(
      CompileDirectiveMetadata component,
      CompileElement parent,
      NodeReference elementRef,
      int nodeIndex,
      ElementAst ast,
      {bool isDeferred});

  /// Creates call to AppView.create to build an AppView.
  ///
  /// contentNodesArray provides projectable nodes to be used during
  /// initialization.
  void createAppView(AppViewReference appViewRef,
      o.Expression componentInstance, o.Expression contentNodesArray);

  /// Projects projectables at sourceAstIndex into target element.
  void projectNodesIntoElement(
      CompileElement target, int sourceAstIndex, NgContentAst ast);

  /// Writes instruction to enable css encapsulation for a node.
  void shimCssForNode(NodeReference nodeReference, int nodeIndex,
      CompileIdentifierMetadata nodeType);

  /// Creates a field to store a stream subscription to be destroyed.
  void createSubscription(o.Expression streamReference, o.Expression handler,
      {bool isMockLike = false});

  /// Add DOM event listener.
  void addDomEventListener(
      NodeReference node, String eventName, o.Expression handler);

  /// Adds event listener that is routed through EventManager for custom
  /// events.
  void addCustomEventListener(
      NodeReference node, String eventName, o.Expression handler);

  /// Initializes query target on component at startup/build time.
  void updateQueryAtStartup(CompileQuery query);

  /// Writes code to update content query targets.
  void updateContentQuery(CompileQuery query);

  /// Creates a provider as a field or local expression.
  o.Expression createProvider(
      String propName,
      CompileDirectiveMetadata directiveMetadata,
      ProviderAst provider,
      List<o.Expression> providerValueExpressions,
      bool isMulti,
      bool isEager,
      CompileElement compileElement,
      {bool forceDynamic = false});

  /// Calls function directive on view startup.
  void callFunctionalDirective(o.Expression invokeExpr);

  /// Creates a pipe and stores reference expression in fieldName.
  void createPipeInstance(String pipeFieldName, CompilePipeMetadata pipeMeta);

  /// Constructs a pure proxy and stores instance in class member.
  void createPureProxy(
      o.Expression fn, int argCount, o.ReadClassMemberExpr pureProxyProp);

  /// Writes literal attribute values on the element itself and those
  /// contributed from directives on the ast node.
  ///
  /// !Component level attributes are excluded since we want to avoid per
  ///  call site duplication.
  void writeLiteralAttributeValues(
      ElementAst elementAst,
      NodeReference elementRef,
      int nodeIndex,
      List<CompileDirectiveMetadata> directives);

  /// Writes code to start defer loading an embedded template.
  void deferLoadEmbeddedTemplate(
      CompileView deferredView, CompileElement targetElement);

  /// Finally writes build statements into target.
  void writeBuildStatements(List<o.Statement> targetStatements);

  /// Writes change detection code for detectChangesInternal method.
  List<o.Statement> writeChangeDetectionStatements();

  /// Adds reference to a provider by token type and nodeIndex range.
  void addInjectable(int nodeIndex, int childNodeCount, ProviderAst provider,
      o.Expression providerExpr, List<CompileTokenMetadata> aliases);

  o.ClassMethod writeInjectorGetMethod();
}

/// Represents data to generate a host, component or embedded AppView.
///
/// Members and method builders are populated by ViewBuilder.
class CompileView implements AppViewBuilder {
  final CompileDirectiveMetadata component;
  final CompilerFlags genConfig;
  final List<CompilePipeMetadata> pipeMetas;
  final o.Expression styles;
  final Map<String, String> deferredModules;

  /// Defines type arguments for generic directives in this view.
  final List<CompileTypedMetadata> directiveTypes;

  /// Whether this is rendered by another view, rather than by its own class.
  ///
  /// Normally a unique class is generated to handle construction and change
  /// detection of each component and embedded view. To avoid this overhead for
  /// simple embedded views created by `NgIf`, this work is instead inlined into
  /// the parent view.
  final bool isInlined;

  /// Whether this inlines any of its child views.
  bool hasInlinedView = false;

  int viewIndex;
  CompileElement declarationElement;
  List<VariableAst> templateVariables;
  ViewType viewType;
  CompileTokenMap<List<CompileQuery>> viewQueries;
  CompileViewStorage storage;

  /// Contains references to view children so we can generate code for
  /// change detection and destroy.
  final List<o.Expression> _viewChildren = [];

  /// Flat list of all nodes inside the template including text nodes.
  List<CompileNode> nodes = [];

  /// List of references to top level nodes in view.
  List<o.Expression> rootNodesOrViewContainers = [];

  /// List of references to view containers used by embedded templates
  /// and child components.
  List<o.Expression> viewContainers = [];
  List<o.Statement> classStatements = [];
  CompileMethod _createMethod;
  CompileMethod _injectorGetMethod;
  CompileMethod _updateContentQueriesMethod;
  CompileMethod _updateViewQueriesMethod;
  CompileMethod dirtyParentQueriesMethod;
  CompileMethod detectChangesInInputsMethod;
  CompileMethod detectChangesRenderPropertiesMethod;
  CompileMethod detectHostChangesMethod;
  CompileMethod afterContentLifecycleCallbacksMethod;
  CompileMethod afterViewLifecycleCallbacksMethod;
  CompileMethod destroyMethod;

  /// Methods generated during view compilation.
  ///
  /// These include event handlers with non-standard parameters or multiple
  /// actions, and internationalized messages with arguments.
  List<o.ClassMethod> methods = [];
  List<o.ClassGetter> getters = [];
  List<o.Expression> subscriptions = [];
  bool subscribesToMockLike = false;
  CompileView componentView;
  var purePipes = Map<String, CompilePipe>();
  List<CompilePipe> pipes = [];
  String className;
  o.OutputType classType;
  o.Expression viewFactory;
  String viewFactoryName;
  bool requiresOnChangesCall = false;
  bool requiresAfterChangesCall = false;
  var pipeCount = 0;
  ViewNameResolver nameResolver;
  static final defaultDocVarName = 'doc';

  /// Local variable name used to refer to document. null if not created yet.
  String docVarName;

  /// The number of internationalized messages in this view.
  var _i18nMessageCount = 0;

  CompileView(
    this.component,
    this.genConfig,
    this.directiveTypes,
    this.pipeMetas,
    this.styles,
    this.viewIndex,
    this.declarationElement,
    this.templateVariables,
    this.deferredModules, {
    this.isInlined = false,
  }) {
    _createMethod = CompileMethod(genDebugInfo);
    _injectorGetMethod = CompileMethod(genDebugInfo);
    _updateContentQueriesMethod = CompileMethod(genDebugInfo);
    dirtyParentQueriesMethod = CompileMethod(genDebugInfo);
    _updateViewQueriesMethod = CompileMethod(genDebugInfo);
    detectChangesInInputsMethod = CompileMethod(genDebugInfo);
    detectChangesRenderPropertiesMethod = CompileMethod(genDebugInfo);
    afterContentLifecycleCallbacksMethod = CompileMethod(genDebugInfo);
    afterViewLifecycleCallbacksMethod = CompileMethod(genDebugInfo);
    destroyMethod = CompileMethod(genDebugInfo);
    if (isInlined) {
      nameResolver = declarationElement.view.nameResolver;
      storage = declarationElement.view.storage;
    } else {
      nameResolver = ViewNameResolver(this);
      storage = CompileViewStorage();
    }
    viewType = _getViewType(component, viewIndex);
    className = '${viewIndex == 0 && viewType != ViewType.host ? '' : '_'}'
        'View${component.type.name}$viewIndex';
    classType = o.importType(CompileIdentifierMetadata(name: className));
    viewFactoryName = getViewFactoryName(component, viewIndex);
    viewFactory = getViewFactory(component, viewFactoryName);
    switch (viewType) {
      case ViewType.host:
      case ViewType.component:
        componentView = this;
        break;
      default:
        // An embedded template uses it's declaration element's componentView.
        componentView = declarationElement.view.componentView;
        break;
    }
    viewQueries = CompileTokenMap<List<CompileQuery>>();
    if (viewType == ViewType.component) {
      var directiveInstance = BuiltInSource(
          identifierToken(this.component.type), o.ReadClassMemberExpr('ctx'));
      var queryIndex = -1;
      for (CompileQueryMetadata metadata in component.viewQueries) {
        queryIndex++;
        final query = CompileQuery.viewQuery(
          metadata: metadata,
          storage: storage,
          queryRoot: this,
          boundDirective: directiveInstance,
          queryIndex: queryIndex,
        );
        addQueryToTokenMap(viewQueries, query);
      }
    }

    for (var variable in templateVariables) {
      nameResolver.addLocal(
        variable.name,
        o.ReadClassMemberExpr('locals').key(o.literal(variable.value)),
        variable.type, // NgFor locals are augmented with type information.
      );
    }
    if (declarationElement.parent != null) {
      declarationElement.setEmbeddedView(this);
    }
    if (deferredModules == null) {
      throw ArgumentError();
    }
  }

  bool get genDebugInfo => genConfig.genDebugInfo;

  // Adds reference to a child view.
  void addViewChild(o.Expression componentViewExpr) {
    _viewChildren.add(componentViewExpr);
  }

  // Returns list of references to view children.
  List<o.Expression> get viewChildren => _viewChildren;

  void afterNodes() {
    for (var pipe in pipes) {
      pipe.create();
    }
    for (var queries in viewQueries.values) {
      for (var query in queries) {
        updateQueryAtStartup(query);
        updateContentQuery(query);
      }
    }
  }

  /// Generates code to internationalize [message].
  ///
  /// Returns an expression that evaluates to the internationalized message.
  o.Expression createI18nMessage(I18nMessage message) {
    var text = message.text;
    if (message.containsHtml) {
      // If the message contains HTML, it will be parsed into a document
      // fragment. To prevent any manually escaped '<' and '>' characters (that
      // were decoded during template parsing) from being interpreted as HTML
      // tags, we must escape them again.
      final htmlEscape = const HtmlEscape(HtmlEscapeMode.element);
      text = htmlEscape.convert(text);
    }
    final args = [
      o.escapedString(text),
      o.NamedExpr('desc', o.literal(message.metadata.description)),
    ];
    if (message.metadata.meaning != null) {
      args.add(o.NamedExpr('meaning', o.literal(message.metadata.meaning)));
    }
    final i18n = o.importExpr(Identifiers.Intl);
    final name = '_message_${_i18nMessageCount++}';
    if (message.containsHtml) {
      // A message with arguments is generated as a static method.
      // These are passed to `args` in `Intl.message()`.
      final messageArgs = <o.ReadVarExpr>[];
      // These are passed to `examples` in `Intl.message()`.
      final messageExamples = <List<dynamic>>[];
      final messageExamplesType = o.MapType(null, [o.TypeModifier.Const]);
      // These are the arguments used to invoke the generated method.
      final methodArgs = <o.LiteralExpr>[];
      // These are the parameters of the generated method.
      final methodParameters = <o.FnParam>[];
      for (final parameter in message.args.keys) {
        final argument = o.literal(message.args[parameter]);
        messageArgs.add(o.variable(parameter));
        messageExamples.add([parameter, argument]);
        methodArgs.add(argument);
        methodParameters.add(o.FnParam(parameter, o.STRING_TYPE));
      }
      args
        ..add(o.NamedExpr('name', o.literal('${className}_$name')))
        ..add(o.NamedExpr('args', o.literalArr(messageArgs)))
        ..add(o.NamedExpr(
          'examples',
          o.literalMap(messageExamples, messageExamplesType),
        ));
      final value = i18n.callMethod('message', args);
      final method = o.ClassMethod(
        name,
        methodParameters,
        [o.ReturnStatement(value)],
        o.STRING_TYPE,
        [o.StmtModifier.Static, o.StmtModifier.Private],
      );
      methods.add(method);
      return o.InvokeMemberMethodExpr(
        name,
        methodArgs,
        outputType: o.STRING_TYPE,
      );
    } else {
      // A message with no arguments is generated as a static final field.
      final value = i18n.callMethod('message', args);
      final item = storage.allocate(
        name,
        outputType: o.STRING_TYPE,
        initializer: value,
        modifiers: const [
          o.StmtModifier.Static,
          o.StmtModifier.Final,
          o.StmtModifier.Private,
        ],
      );
      return storage.buildReadExpr(item);
    }
  }

  @override
  NodeReference createHtml(
    CompileElement parent,
    int nodeIndex,
    o.Expression html,
  ) {
    final renderNode = NodeReference.html(parent, nodeIndex);
    _createMethod.addStmt(o.DeclareVarStmt(
      renderNode._name,
      o.importExpr(Identifiers.createTrustedHtml).callFn([html]),
      o.importType(Identifiers.HTML_DOCUMENT_FRAGMENT),
    ));
    final parentRenderNodeExpr = _getParentRenderNode(parent);
    if (parentRenderNodeExpr != o.NULL_EXPR) {
      _createMethod.addStmt(parentRenderNodeExpr
          .callMethod('append', [renderNode.toReadExpr()]).toStmt());
    }
    return renderNode;
  }

  @override
  NodeReference createTextNode(CompileElement parent, int nodeIndex,
      o.Expression text, TemplateAst ast) {
    NodeReference renderNode;
    if (isInlined) {
      renderNode = NodeReference.inlinedTextNode(
          parent, declarationElement.nodeIndex, nodeIndex);
      storage.allocate(renderNode._name,
          outputType: o.importType(Identifiers.HTML_TEXT_NODE),
          modifiers: const [o.StmtModifier.Private]);
      _createMethod.addStmt(renderNode
          .toWriteExpr(
              o.importExpr(Identifiers.HTML_TEXT_NODE).instantiate([text]))
          .toStmt());
    } else {
      renderNode = NodeReference.textNode(parent, nodeIndex);
      renderNode.lockVisibility(NodeReferenceVisibility.build);
      _createMethod.addStmt(o.DeclareVarStmt(
          renderNode._name,
          o.importExpr(Identifiers.HTML_TEXT_NODE).instantiate([text]),
          o.importType(Identifiers.HTML_TEXT_NODE)));
    }
    var parentRenderNodeExpr = _getParentRenderNode(parent);
    if (parentRenderNodeExpr != null && parentRenderNodeExpr != o.NULL_EXPR) {
      // Write append code.
      _createMethod.addStmt(parentRenderNodeExpr
          .callMethod('append', [renderNode.toReadExpr()]).toStmt());
    }
    return renderNode;
  }

  @override
  NodeReference createBoundTextNode(
      CompileElement parent, int nodeIndex, BoundTextAst ast) {
    // If Text field is bound, we need access to the renderNode beyond
    // build method and write reference to class member.
    NodeReference renderNode = NodeReference.textNode(parent, nodeIndex);
    ViewStorageItem renderNodeItem = storage.allocate(renderNode._name,
        outputType: o.importType(Identifiers.HTML_TEXT_NODE),
        modifiers: const [o.StmtModifier.Private]);

    var parentRenderNodeExpr = _getParentRenderNode(parent);
    o.Expression initialText = o.literal('');
    if (component.analyzedClass != null &&
        isImmutable(ast.value, component.analyzedClass)) {
      var newValue = rewriteInterpolate(ast.value, component.analyzedClass);
      initialText = convertCdExpressionToIr(
        nameResolver,
        o.ReadClassMemberExpr('ctx'),
        newValue,
        ast.sourceSpan,
        component,
        o.STRING_TYPE,
      );
    }
    var createRenderNodeExpr = storage.buildWriteExpr(renderNodeItem,
        o.importExpr(Identifiers.HTML_TEXT_NODE).instantiate([initialText]));
    _createMethod.addStmt(createRenderNodeExpr.toStmt());

    if (parentRenderNodeExpr != null && parentRenderNodeExpr != o.NULL_EXPR) {
      // Write append code.
      _createMethod.addStmt(parentRenderNodeExpr
          .callMethod('append', [renderNode.toReadExpr()]).toStmt());
    }
    return renderNode;
  }

  /// Create an html node and appends to parent element.
  void createElement(CompileElement parent, NodeReference elementRef,
      int nodeIndex, String tagName, TemplateAst ast) {
    var parentRenderNodeExpr = _getParentRenderNode(parent);
    final generateDebugInfo = genConfig.genDebugInfo;

    if (!_isRootNodeOfHost(nodeIndex)) {
      String name = (elementRef.toReadExpr() as o.ReadClassMemberExpr).name;
      storage.allocate(name,
          outputType: o.importType(identifierFromTagName(tagName)),
          modifiers: const [o.StmtModifier.Private]);
    }

    _createElementAndAppend(tagName, parentRenderNodeExpr, elementRef,
        generateDebugInfo, ast.sourceSpan, nodeIndex);
  }

  void _createElementAndAppend(
      String tagName,
      o.Expression parent,
      NodeReference elementRef,
      bool generateDebugInfo,
      SourceSpan debugSpan,
      int debugNodeIndex) {
    // No namespace just call [document.createElement].
    if (docVarName == null) {
      _createMethod.addStmt(_createLocalDocumentVar());
    }

    if (parent != null && parent != o.NULL_EXPR) {
      o.Expression createExpr;
      final createParams = <o.Expression>[o.ReadVarExpr(docVarName)];

      CompileIdentifierMetadata createAndAppendMethod;
      switch (tagName) {
        case 'div':
          createAndAppendMethod = Identifiers.createDivAndAppend;
          break;
        case 'span':
          createAndAppendMethod = Identifiers.createSpanAndAppend;
          break;
        default:
          createAndAppendMethod = Identifiers.createAndAppend;
          createParams.add(o.literal(tagName));
          break;
      }
      createParams.add(parent);
      createExpr = o.importExpr(createAndAppendMethod).callFn(createParams);
      _createMethod.addStmt(elementRef.toWriteExpr(createExpr).toStmt());
    } else {
      // No parent node, just create element and assign.
      var createRenderNodeExpr = o.ReadVarExpr(docVarName)
          .callMethod('createElement', [o.literal(tagName)]);
      _createMethod
          .addStmt(elementRef.toWriteExpr(createRenderNodeExpr).toStmt());
    }
  }

  o.Statement _createLocalDocumentVar() {
    docVarName = defaultDocVarName;
    return o.DeclareVarStmt(
        docVarName, o.importExpr(Identifiers.HTML_DOCUMENT));
  }

  /// Creates an html node with a namespace and appends to parent element.
  void createElementNs(CompileElement parent, NodeReference elementRef,
      int nodeIndex, String ns, String tagName, TemplateAst ast) {
    var parentRenderNodeExpr = _getParentRenderNode(parent);
    if (docVarName == null) {
      _createMethod.addStmt(_createLocalDocumentVar());
    }

    if (!_isRootNodeOfHost(nodeIndex)) {
      String name = (elementRef.toReadExpr() as o.ReadClassMemberExpr).name;
      storage.allocate(name,
          outputType: o.importType(identifierFromTagName('$ns:$tagName')),
          modifiers: const [o.StmtModifier.Private]);
    }
    var createRenderNodeExpr = o
        .variable(docVarName)
        .callMethod('createElementNS', [o.literal(ns), o.literal(tagName)]);
    _createMethod
        .addStmt(elementRef.toWriteExpr(createRenderNodeExpr).toStmt());
    if (parentRenderNodeExpr != null && parentRenderNodeExpr != o.NULL_EXPR) {
      // Write code to append to parent node.
      _createMethod.addStmt(parentRenderNodeExpr
          .callMethod('append', [elementRef.toReadExpr()]).toStmt());
    }
  }

  /// Adds a field member that holds the reference to a child app view for
  /// a hosted component.
  AppViewReference _createAppViewNodeAndComponent(
      CompileElement parent,
      CompileDirectiveMetadata childComponent,
      NodeReference elementRef,
      int nodeIndex,
      bool isDeferred,
      ElementAst ast) {
    CompileIdentifierMetadata componentViewIdentifier =
        CompileIdentifierMetadata(
            name: 'View${childComponent.type.name}0',
            moduleUrl: templateModuleUrl(childComponent.type));

    bool isHostRootView = nodeIndex == 0 && viewType == ViewType.host;
    var elementType = isHostRootView
        ? Identifiers.HTML_HTML_ELEMENT
        : identifierFromTagName(ast.name);

    if (!isHostRootView) {
      storage.allocate(elementRef._name,
          outputType: o.importType(elementType),
          modifiers: const [o.StmtModifier.Private]);
    }

    AppViewReference appViewRef = AppViewReference(parent, nodeIndex);

    // For non-deferred generic components, these type arguments (if any) can be
    // applied to the field that stores the view. However, for deferred
    // components, the field can't be explicitly typed so these type arguments
    // are instead applied to the constructor invocation.
    final appViewTypeArguments =
        lookupTypeArgumentsOf(childComponent.type, ast);
    final appViewType = isDeferred
        ? o.importType(Identifiers.AppView)
        : o.importType(componentViewIdentifier, appViewTypeArguments);

    storage.allocate(appViewRef._name, outputType: appViewType);

    if (isDeferred) {
      // When deferred, we use AppView<dynamic> as type to store instance
      // of component and create the instance using:
      // deferredLibName.viewFactory_SomeComponent(...)
      CompileIdentifierMetadata nestedComponentIdentifier =
          CompileIdentifierMetadata(
              name: getViewFactoryName(childComponent, 0),
              moduleUrl: templateModuleUrl(childComponent.type));

      var importExpr = o.importExpr(nestedComponentIdentifier);
      _createMethod.addStmt(o.WriteClassMemberExpr(
          appViewRef._name,
          importExpr.callFn(
            [o.THIS_EXPR, o.literal(nodeIndex)],
            typeArguments: appViewTypeArguments,
          )).toStmt());
    } else {
      // Create instance of component using ViewSomeComponent0 AppView.
      var createComponentInstanceExpr = o
          .importExpr(componentViewIdentifier)
          .instantiate([o.THIS_EXPR, o.literal(nodeIndex)]);
      _createMethod.addStmt(
          o.WriteClassMemberExpr(appViewRef._name, createComponentInstanceExpr)
              .toStmt());
    }
    return appViewRef;
  }

  /// Creates a node 'anchor' to mark the insertion point for dynamically
  /// created elements.
  ///
  /// If [topLevel] is `true`, the anchor node is available to any method in the
  /// view. This is useful for inlined views, which are built in the
  /// `detectChanges` method. Otherwise, the anchor is local to this view's
  /// build method.
  NodeReference createViewContainerAnchor(
      CompileElement parent, int nodeIndex, TemplateAst ast, bool topLevel) {
    var visibility = topLevel
        ? NodeReferenceVisibility.classPublic
        : NodeReferenceVisibility.build;
    NodeReference renderNode =
        NodeReference.anchor(parent, nodeIndex, visibility);
    if (topLevel) {
      storage.allocate(renderNode._name,
          outputType: o.importType(Identifiers.HTML_COMMENT_NODE));
    }
    o.Expression createAnchor =
        o.importExpr(Identifiers.createViewContainerAnchor).callFn([]);
    o.Expression assignCloneAnchorNodeExpr =
        renderNode.toWriteExpr(createAnchor);
    o.Statement assignCloneAnchorStmt;
    if (topLevel) {
      assignCloneAnchorStmt = assignCloneAnchorNodeExpr.toStmt();
    } else {
      assignCloneAnchorStmt = (assignCloneAnchorNodeExpr as o.WriteVarExpr)
          .toDeclStmt(null, [o.StmtModifier.Final]);
    }
    _createMethod.addStmt(assignCloneAnchorStmt);
    var parentNode = _getParentRenderNode(parent);
    if (parentNode != o.NULL_EXPR) {
      var addCommentStmt =
          parentNode.callMethod('append', [renderNode.toReadExpr()]).toStmt();
      _createMethod.addStmt(addCommentStmt);
    }
    return renderNode;
  }

  @override
  o.ReadClassMemberExpr createViewContainer(
      NodeReference nodeReference, int nodeIndex, bool isPrivate,
      [int parentNodeIndex]) {
    o.Expression renderNode = nodeReference.toReadExpr();
    var fieldName = '_appEl_$nodeIndex';
    // Create instance field for app element.
    storage.allocate(fieldName,
        outputType: o.importType(Identifiers.ViewContainer),
        modifiers: [o.StmtModifier.Private]);

    // Write code to create an instance of ViewContainer.
    // Example:
    //     this._appEl_2 = new import7.ViewContainer(2,0,this,this._anchor_2);
    var statement = o.WriteClassMemberExpr(
        fieldName,
        o.importExpr(Identifiers.ViewContainer).instantiate([
          o.literal(nodeIndex),
          o.literal(parentNodeIndex),
          o.THIS_EXPR,
          renderNode
        ])).toStmt();
    _createMethod.addStmt(statement);
    var appViewContainer = o.ReadClassMemberExpr(fieldName);
    if (!isPrivate) {
      viewContainers.add(appViewContainer);
    }
    return appViewContainer;
  }

  @override
  AppViewReference createComponentNodeAndAppend(
      CompileDirectiveMetadata component,
      CompileElement parent,
      NodeReference elementRef,
      int nodeIndex,
      ElementAst ast,
      {bool isDeferred}) {
    AppViewReference compAppViewExpr = _createAppViewNodeAndComponent(
        parent, component, elementRef, nodeIndex, isDeferred, ast);

    if (_isRootNodeOfHost(nodeIndex)) {
      // Assign root element created by viewfactory call to our own root.
      _createMethod.addStmt(elementRef
          .toWriteExpr(
              compAppViewExpr.toReadExpr().prop(appViewRootElementName))
          .toStmt());
    } else {
      var parentRenderNodeExpr = _getParentRenderNode(parent);
      _createMethod.addStmt(elementRef
          .toWriteExpr(
              compAppViewExpr.toReadExpr().prop(appViewRootElementName))
          .toStmt());
      if (parentRenderNodeExpr != null && parentRenderNodeExpr != o.NULL_EXPR) {
        // Write code to append to parent node.
        _createMethod.addStmt(parentRenderNodeExpr
            .callMethod('append', [elementRef.toReadExpr()]).toStmt());
      }
    }
    return compAppViewExpr;
  }

  @override
  void createAppView(AppViewReference appViewRef,
      o.Expression componentInstance, o.Expression contentNodesArray) {
    _createMethod.addStmt(appViewRef
        .toReadExpr()
        .callMethod('create', [componentInstance, contentNodesArray]).toStmt());
  }

  bool _isRootNodeOfHost(int nodeIndex) =>
      nodeIndex == 0 && viewType == ViewType.host;

  @override
  void projectNodesIntoElement(
      CompileElement target, int sourceAstIndex, NgContentAst ast) {
    // The projected nodes originate from a different view, so we don't
    // have debug information for them.
    var parentRenderNode = _getParentRenderNode(target);
    // AppView.projectableNodes property contains the list of nodes
    // to project for each NgContent.
    // Creates a call to project(parentNode, nodeIndex).
    var nodesExpression = ViewProperties.projectableNodes.key(
        o.literal(sourceAstIndex),
        o.ArrayType(o.importType(Identifiers.HTML_NODE)));
    bool isRootNode = !identical(target.view, this);
    if (!identical(parentRenderNode, o.NULL_EXPR)) {
      _createMethod.addStmt(o.InvokeMemberMethodExpr(
          'project', [parentRenderNode, o.literal(ast.index)]).toStmt());
    } else if (isRootNode) {
      if (!identical(viewType, ViewType.component)) {
        // store root nodes only for embedded/host views
        rootNodesOrViewContainers.add(nodesExpression);
      }
    } else {
      if (target.component != null && ast.ngContentIndex != null) {
        target.addContentNode(ast.ngContentIndex, nodesExpression);
      }
    }
  }

  @override
  void shimCssForNode(NodeReference nodeReference, int nodeIndex,
      CompileIdentifierMetadata nodeType) {
    if (_isRootNodeOfHost(nodeIndex)) return;
    if (component.template.encapsulation == ViewEncapsulation.Emulated) {
      // Set ng_content class for CSS shim.
      String shimMethod =
          nodeType != Identifiers.HTML_ELEMENT ? 'addShimC' : 'addShimE';
      o.Expression shimClassExpr =
          o.InvokeMemberMethodExpr(shimMethod, [nodeReference.toReadExpr()]);
      _createMethod.addStmt(shimClassExpr.toStmt());
    }
  }

  @override
  void createSubscription(o.Expression streamReference, o.Expression handler,
      {bool isMockLike = false}) {
    final subscription = o.variable('subscription_${subscriptions.length}');
    subscriptions.add(subscription);
    _createMethod.addStmt(subscription
        .set(streamReference.callMethod(
            o.BuiltinMethod.SubscribeObservable, [handler],
            checked: isMockLike))
        .toDeclStmt(null, [o.StmtModifier.Final]));
    if (isMockLike) {
      subscribesToMockLike = true;
    }
  }

  @override
  void addDomEventListener(
      NodeReference node, String eventName, o.Expression handler) {
    var listenExpr = node
        .toReadExpr()
        .callMethod('addEventListener', [o.literal(eventName), handler]);
    _createMethod.addStmt(listenExpr.toStmt());
  }

  @override
  void addCustomEventListener(
      NodeReference node, String eventName, o.Expression handler) {
    final appViewUtilsExpr = o.importExpr(Identifiers.appViewUtils);
    final eventManagerExpr = appViewUtilsExpr.prop('eventManager');
    var listenExpr = eventManagerExpr.callMethod(
        'addEventListener', [node.toReadExpr(), o.literal(eventName), handler]);
    _createMethod.addStmt(listenExpr.toStmt());
  }

  @override
  void updateQueryAtStartup(CompileQuery query) {
    _createMethod.addStmts(query.createImmediateUpdates());
  }

  @override
  void updateContentQuery(CompileQuery query) {
    _updateContentQueriesMethod.addStmts(query.createDynamicUpdates());
  }

  /// Creates a class field and assigns the resolvedProviderValueExpr.
  ///
  /// Eager Example:
  ///   _TemplateRef_9_4 =
  ///       new TemplateRef(_appEl_9,viewFactory_SampleComponent7);
  ///
  /// Lazy:
  ///
  /// TemplateRef _TemplateRef_9_4;
  ///
  @override
  o.Expression createProvider(
      String propName,
      CompileDirectiveMetadata directiveMetadata,
      ProviderAst provider,
      List<o.Expression> providerValueExpressions,
      bool isMulti,
      bool isEager,
      CompileElement compileElement,
      {bool forceDynamic = false}) {
    o.Expression resolvedProviderValueExpr;
    o.OutputType type;
    if (isMulti) {
      resolvedProviderValueExpr = o.literalArr(providerValueExpressions);
      type = o.ArrayType(provider.typeArgument != null
          ? o.importType(
              provider.typeArgument,
              provider.typeArgument.typeArguments,
            )
          : o.DYNAMIC_TYPE);
    } else {
      resolvedProviderValueExpr = providerValueExpressions.first;
      if (directiveMetadata != null) {
        // If the provider is backed by a directive, use the directive type
        // alongside any specified type arguments to type the field.
        type = o.importType(
          directiveMetadata.originType,
          lookupTypeArgumentsOf(
            directiveMetadata.originType,
            compileElement.sourceAst,
          ),
        );
      } else if (provider.typeArgument != null) {
        type = o.importType(
          provider.typeArgument,
          provider.typeArgument.typeArguments,
        );
      } else {
        type = resolvedProviderValueExpr.type;
      }
    }

    type ??= o.DYNAMIC_TYPE;

    bool providerHasChangeDetector =
        provider.providerType == ProviderAstType.Directive &&
            directiveMetadata != null &&
            directiveMetadata.requiresDirectiveChangeDetector;

    CompileIdentifierMetadata changeDetectorClass;
    o.OutputType changeDetectorType;
    if (providerHasChangeDetector) {
      changeDetectorClass = CompileIdentifierMetadata(
          name: directiveMetadata.identifier.name + 'NgCd',
          moduleUrl:
              toTemplateExtension(directiveMetadata.identifier.moduleUrl));
      changeDetectorType = o.importType(
        changeDetectorClass,
        lookupTypeArgumentsOf(
          directiveMetadata.originType,
          compileElement.sourceAst,
        ),
      );
    }

    List<o.Expression> changeDetectorParams;
    if (providerHasChangeDetector) {
      // ignore: list_element_type_not_assignable
      changeDetectorParams = [resolvedProviderValueExpr];
      if (directiveMetadata.changeDetection ==
          ChangeDetectionStrategy.Stateful) {
        changeDetectorParams.add(o.THIS_EXPR);
        changeDetectorParams.add(compileElement.renderNode.toReadExpr());
      }
    }

    if (isEager) {
      // Check if we need to reach this directive or component beyond the
      // contents of the build() function. Otherwise allocate locally.
      if (compileElement.publishesTemplateRef ||
          compileElement.hasTemplateRefQuery ||
          provider.dynamicallyReachable) {
        if (providerHasChangeDetector) {
          ViewStorageItem item = storage.allocate(propName,
              outputType: changeDetectorType,
              modifiers: const [o.StmtModifier.Private]);
          _createMethod.addStmt(storage
              .buildWriteExpr(
                  item,
                  o
                      .importExpr(changeDetectorClass)
                      .instantiate(changeDetectorParams))
              .toStmt());
          return o.ReadPropExpr(
              o.ReadClassMemberExpr(propName, changeDetectorType), 'instance',
              outputType: forceDynamic ? o.DYNAMIC_TYPE : type);
        } else {
          ViewStorageItem item = storage.allocate(propName,
              outputType: forceDynamic ? o.DYNAMIC_TYPE : type,
              modifiers: const [o.StmtModifier.Private]);
          _createMethod.addStmt(
              storage.buildWriteExpr(item, resolvedProviderValueExpr).toStmt());
        }
      } else {
        // Since provider is not dynamically reachable and we only need
        // the provider locally in build, create a local var.
        var localVar =
            o.variable(propName, forceDynamic ? o.DYNAMIC_TYPE : type);
        _createMethod
            .addStmt(localVar.set(resolvedProviderValueExpr).toDeclStmt());
        return localVar;
      }
    } else {
      // We don't have to eagerly initialize this object. Add an uninitialized
      // class field and provide a getter to construct the provider on demand.
      var internalFieldName = '_$propName';
      ViewStorageItem internalField = storage.allocate(internalFieldName,
          outputType: forceDynamic
              ? o.DYNAMIC_TYPE
              : (providerHasChangeDetector ? changeDetectorType : type),
          modifiers: const [o.StmtModifier.Private]);
      var getter = CompileMethod(genDebugInfo);

      if (providerHasChangeDetector) {
        resolvedProviderValueExpr =
            o.importExpr(changeDetectorClass).instantiate(changeDetectorParams);
      }
      // Note: Equals is important for JS so that it also checks the undefined case!
      var statements = <o.Statement>[
        storage
            .buildWriteExpr(internalField, resolvedProviderValueExpr)
            .toStmt()
      ];
      var readVars = o.findReadVarNames(statements);
      if (readVars.contains(cachedParentIndexVarName)) {
        statements.insert(
            0,
            o.DeclareVarStmt(cachedParentIndexVarName,
                o.ReadClassMemberExpr('viewData').prop('parentIndex')));
      }
      getter.addStmt(
          o.IfStmt(storage.buildReadExpr(internalField).isBlank(), statements));
      getter.addStmt(o.ReturnStatement(storage.buildReadExpr(internalField)));
      getters.add(o.ClassGetter(
          propName,
          getter.finish(),
          forceDynamic
              ? o.DYNAMIC_TYPE
              : (providerHasChangeDetector ? changeDetectorType : type)));
    }
    return o.ReadClassMemberExpr(propName, type);
  }

  @override
  void callFunctionalDirective(o.Expression invokeExpression) {
    _createMethod.addStmt(invokeExpression.toStmt());
  }

  @override
  void createPipeInstance(String name, CompilePipeMetadata pipeMeta) {
    var deps = pipeMeta.type.diDeps.map((diDep) {
      if (diDep.token
          .equalsTo(identifierToken(Identifiers.ChangeDetectorRef))) {
        return o.ReadClassMemberExpr('ref');
      }
      return injectFromViewParentInjector(this, diDep.token, false);
    }).toList();
    ViewStorageItem pipeInstance = storage.allocate(name,
        outputType: o.importType(pipeMeta.type),
        modifiers: [o.StmtModifier.Private]);
    _createMethod.addStmt(storage
        .buildWriteExpr(
            pipeInstance, o.importExpr(pipeMeta.type).instantiate(deps))
        .toStmt());
  }

  @override
  void createPureProxy(
    o.Expression fn,
    int argCount,
    o.ReadClassMemberExpr pureProxyProp, {
    o.OutputType pureProxyType,
  }) {
    ViewStorageItem proxy = storage.allocate(
      pureProxyProp.name,
      outputType: pureProxyType,
      modifiers: const [o.StmtModifier.Private],
    );
    var pureProxyId = argCount < Identifiers.pureProxies.length
        ? Identifiers.pureProxies[argCount]
        : null;
    if (pureProxyId == null) {
      throw StateError(
          'Unsupported number of argument for pure functions: $argCount');
    }
    _createMethod.addStmt(storage
        .buildWriteExpr(proxy, o.importExpr(pureProxyId).callFn([fn]))
        .toStmt());
  }

  @override
  void writeLiteralAttributeValues(
      ElementAst elementAst,
      NodeReference nodeReference,
      int nodeIndex,
      List<CompileDirectiveMetadata> directives) {
    List<AttrAst> attrs = elementAst.attrs;
    var htmlAttrs = astAttribListToMap(attrs);
    // Create statements to initialize literal attribute values.
    // For example, a directive may have hostAttributes setting class name.
    var attrNameAndValues = mergeHtmlAndDirectiveAttrs(htmlAttrs, directives);
    attrNameAndValues.forEach((name, value) {
      var expression = convertCdExpressionToIr(
        nameResolver,
        o.THIS_EXPR,
        value,
        // While the expression being converted may be the merged result of
        // several bindings (a template binding and/or any number of host
        // bindings), the only kind that could fail conversion is a template
        // binding, so we pass its source span if present.
        htmlAttrs[name]?.sourceSpan,
        component,
        o.STRING_TYPE,
      );
      o.Statement stmt = createSetAttributeStatement(
          elementAst.name, nodeReference.toReadExpr(), name, expression);
      _createMethod.addStmt(stmt);
    });
    for (final i18nAttr in elementAst.i18nAttrs) {
      // Don't set any internationalized attributes that were overriden by a
      // directive host binding.
      if (!attrNameAndValues.containsKey(i18nAttr.name)) {
        final message = createI18nMessage(i18nAttr.value);
        final stmt = createSetAttributeStatement(elementAst.name,
            nodeReference.toReadExpr(), i18nAttr.name, message);
        _createMethod.addStmt(stmt);
      }
    }
  }

  @override
  void deferLoadEmbeddedTemplate(
      CompileView deferredView, CompileElement targetElement) {
    var statements = <o.Statement>[];
    targetElement.writeDeferredLoader(
        deferredView, targetElement.appViewContainer, statements);
    _createMethod.addStmts(statements);
    detectChangesRenderPropertiesMethod.addStmt(targetElement.appViewContainer
        .callMethod('detectChangesInNestedViews', const []).toStmt());
  }

  @override
  void writeBuildStatements(List<o.Statement> targetStatements) {
    targetStatements.addAll(_createMethod.finish());
  }

  @override
  List<o.Statement> writeChangeDetectionStatements() {
    var statements = <o.Statement>[];
    if (detectChangesInInputsMethod.isEmpty &&
        _updateContentQueriesMethod.isEmpty &&
        afterContentLifecycleCallbacksMethod.isEmpty &&
        detectChangesRenderPropertiesMethod.isEmpty &&
        _updateViewQueriesMethod.isEmpty &&
        afterViewLifecycleCallbacksMethod.isEmpty &&
        viewChildren.isEmpty &&
        viewContainers.isEmpty) {
      return statements;
    }

    if (genConfig.profileFor == Profile.build) {
      genProfileCdStart(this, statements);
    }

    // Declare variables for locals used in this method.
    statements.addAll(nameResolver.getLocalDeclarations());

    // Add @Input change detectors.
    statements.addAll(detectChangesInInputsMethod.finish());

    // Add content child change detection calls.
    for (o.Expression contentChild in viewContainers) {
      statements.add(
          contentChild.callMethod('detectChangesInNestedViews', []).toStmt());
    }

    // Add Content query updates.
    List<o.Statement> afterContentStmts =
        List.from(_updateContentQueriesMethod.finish())
          ..addAll(afterContentLifecycleCallbacksMethod.finish());
    if (afterContentStmts.isNotEmpty) {
      statements.add(o.IfStmt(notThrowOnChanges, afterContentStmts));
    }

    // Add render properties change detectors.
    statements.addAll(detectChangesRenderPropertiesMethod.finish());

    // Add view child change detection calls.
    for (o.Expression viewChild in viewChildren) {
      statements.add(viewChild.callMethod('detectChanges', []).toStmt());
    }

    List<o.Statement> afterViewStmts =
        List.from(_updateViewQueriesMethod.finish())
          ..addAll(afterViewLifecycleCallbacksMethod.finish());
    if (afterViewStmts.isNotEmpty) {
      statements.add(o.IfStmt(notThrowOnChanges, afterViewStmts));
    }
    var varStmts = [];
    var readVars = o.findReadVarNames(statements);
    var writeVars = o.findWriteVarNames(statements);
    if (readVars.contains(cachedParentIndexVarName)) {
      varStmts.add(o.DeclareVarStmt(cachedParentIndexVarName,
          o.ReadClassMemberExpr('viewData').prop('parentIndex')));
    }
    if (readVars.contains(DetectChangesVars.cachedCtx.name)) {
      // Cache [ctx] class field member as typed [_ctx] local for change
      // detection code to consume.
      var contextType =
          viewType != ViewType.host ? o.importType(component.type) : null;
      varStmts.add(o
          .variable(DetectChangesVars.cachedCtx.name)
          .set(o.ReadClassMemberExpr('ctx'))
          .toDeclStmt(contextType, [o.StmtModifier.Final]));
    }
    if (readVars.contains(DetectChangesVars.changed.name) ||
        writeVars.contains(DetectChangesVars.changed.name)) {
      varStmts.add(DetectChangesVars.changed
          .set(o.literal(false))
          .toDeclStmt(o.BOOL_TYPE));
    }
    if (readVars.contains(DetectChangesVars.changes.name) ||
        requiresOnChangesCall) {
      varStmts.add(o.DeclareVarStmt(DetectChangesVars.changes.name, null,
          o.MapType(o.importType(Identifiers.SimpleChange))));
    }
    if (readVars.contains(DetectChangesVars.firstCheck.name)) {
      varStmts.add(o.DeclareVarStmt(
          DetectChangesVars.firstCheck.name,
          o.THIS_EXPR
              .prop('cdState')
              .equals(o.literal(ChangeDetectorState.NeverChecked)),
          o.BOOL_TYPE));
    }
    if (genConfig.profileFor == Profile.build) {
      genProfileCdEnd(this, statements);
    }
    return List.from(varStmts)..addAll(statements);
  }

  @override
  void addInjectable(
    int nodeIndex,
    int childNodeCount,
    ProviderAst provider,
    o.Expression providerExpr,
    List<CompileTokenMetadata> aliases,
  ) {
    final tokenConditions = <o.Expression>[];
    if (provider.visibleForInjection) {
      tokenConditions.add(_createTokenCondition(provider.token));
    }
    if (aliases != null) {
      for (final alias in aliases) {
        tokenConditions.add(_createTokenCondition(alias));
      }
    }
    if (tokenConditions.isEmpty) return; // No visible tokens for this provider.
    final tokenCondition = tokenConditions
        .reduce((expression, condition) => expression.or(condition));
    final indexCondition = _createIndexCondition(nodeIndex, childNodeCount);
    final condition = tokenCondition.and(indexCondition);
    _injectorGetMethod
        .addStmt(o.IfStmt(condition, [o.ReturnStatement(providerExpr)]));
  }

  @override
  o.ClassMethod writeInjectorGetMethod() {
    return o.ClassMethod(
        "injectorGetInternal",
        [
          o.FnParam(InjectMethodVars.token.name, o.DYNAMIC_TYPE),
          o.FnParam(InjectMethodVars.nodeIndex.name, o.INT_TYPE),
          o.FnParam(InjectMethodVars.notFoundResult.name, o.DYNAMIC_TYPE)
        ],
        _addReturnValueIfNotEmpty(
            _injectorGetMethod.finish(), InjectMethodVars.notFoundResult),
        o.DYNAMIC_TYPE,
        null,
        ['override']);
  }

  // Returns reference for compile element or null if compile element
  // has no attached node (root node of embedded or host view).
  o.Expression _getParentRenderNode(CompileElement parentElement) {
    bool isRootNode = !identical(parentElement.view, this);
    if (isRootNode) {
      if (viewType == ViewType.component) {
        return parentRenderNodeVar;
      } else {
        // root node of an embedded/host view
        return o.NULL_EXPR;
      }
    } else {
      // If our parent element is a component, this is transcluded content
      // and we should return null since there is no physical element in
      // this view. Otherwise return the actual html node reference.
      return parentElement.component != null
          ? o.NULL_EXPR
          : parentElement.renderNode.toReadExpr();
    }
  }

  /// Returns any type arguments specified for [rawDirectiveType] on [hostAst].
  ///
  /// Returns an empty list if no matching type arguments are found.
  List<o.OutputType> lookupTypeArgumentsOf(
    CompileTypeMetadata rawDirectiveType,
    TemplateAst hostAst,
  ) {
    if (rawDirectiveType.typeParameters.isEmpty) {
      return [];
    }
    var references = <ReferenceAst>[];
    if (hostAst is ElementAst) {
      references = hostAst.references;
    } else if (hostAst is EmbeddedTemplateAst) {
      references = hostAst.references;
    }
    // Given two `Typed` configurations that match the same directive:
    //  * One that specifies `on` takes precedence over one that doesn't.
    //  * Otherwise the first match takes precedence over any others.
    List<o.OutputType> firstMatchingTypeArguments;
    for (final directiveType in directiveTypes) {
      if (directiveType.name == rawDirectiveType.name &&
          directiveType.moduleUrl == rawDirectiveType.moduleUrl) {
        if (directiveType.on != null) {
          // If `on` is specified, the type arguments only apply if the
          // directive's host element has a matching reference name.
          for (final reference in references) {
            if (directiveType.on == reference.name) {
              return directiveType.typeArguments;
            }
          }
        } else if (firstMatchingTypeArguments == null) {
          // Otherwise the type arguments apply to all instances of the
          // directive in the view.
          if (references.isEmpty) {
            // If the directive's host element has no references, it's not
            // possible for more specific type arguments to be applied, so we
            // return the first match.
            return directiveType.typeArguments;
          } else {
            // Otherwise we remember the first matching type arguments so that
            // they may be applied if reference matching type arguments aren't
            // later specified.
            firstMatchingTypeArguments = directiveType.typeArguments;
          }
        }
      }
    }
    return firstMatchingTypeArguments ?? [];
  }
}

ViewType _getViewType(
    CompileDirectiveMetadata component, int embeddedTemplateIndex) {
  if (embeddedTemplateIndex > 0) {
    return ViewType.embedded;
  } else if (component.type.isHost) {
    return ViewType.host;
  } else {
    return ViewType.component;
  }
}

List<o.Statement> _addReturnValueIfNotEmpty(
    List<o.Statement> statements, o.Expression value) {
  if (statements.isEmpty) {
    return statements;
  } else {
    return List.from(statements)..addAll([o.ReturnStatement(value)]);
  }
}

/// Creates an expression to check that 'nodeIndex' is in the given range.
///
/// The given range is inclusive: [start, start + length].
o.Expression _createIndexCondition(int start, int length) {
  final index = InjectMethodVars.nodeIndex;
  final lowerBound = o.literal(start);
  if (length > 0) {
    final upperBound = o.literal(start + length);
    return lowerBound.lowerEquals(index).and(index.lowerEquals(upperBound));
  } else {
    return lowerBound.equals(index);
  }
}

/// Creates an expression to check that 'token' is identical to a [token].
o.Expression _createTokenCondition(CompileTokenMetadata token) =>
    InjectMethodVars.token.identical(createDiTokenExpression(token));

/// CompileView implementation of ViewStorage which stores instances as
/// class member fields on the AppView class.
///
/// Storage is used to share instances with child views and
/// to share data between build and change detection methods.
///
/// The CompileView reuses simple ClassField(s) to implement storage for
/// runtime.
class CompileViewStorage implements ViewStorage {
  final List<o.ClassField> fields = [];

  @override
  ViewStorageItem allocate(String name,
      {o.OutputType outputType,
      List<o.StmtModifier> modifiers,
      o.Expression initializer}) {
    fields.add(o.ClassField(name,
        outputType: outputType,
        modifiers: modifiers,
        initializer: initializer));
    return ViewStorageItem(name,
        outputType: outputType, modifiers: modifiers, initializer: initializer);
  }

  @override
  o.Expression buildWriteExpr(ViewStorageItem item, o.Expression value) {
    return o.WriteClassMemberExpr(item.name, value);
  }

  @override
  o.Expression buildReadExpr(ViewStorageItem item) {
    return o.ReadClassMemberExpr(item.name, item.outputType);
  }
}
