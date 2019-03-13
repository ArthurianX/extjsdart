// **************************************************************************
// Generator: Instance of 'Compiler'
// **************************************************************************

// ignore_for_file: cancel_subscriptions,constant_identifier_names,duplicate_import,non_constant_identifier_names,library_prefixes,UNUSED_IMPORT,UNUSED_SHOWN_NAME
import 'beta_component.dart';
export 'beta_component.dart';
import 'package:angular/angular.dart';
import 'package:my_angular_dart_project/outside_provider.dart';
import 'package:angular/src/di/reflector.dart' as _ngRef;
import 'package:angular/angular.template.dart' as _ref0;
import 'package:my_angular_dart_project/outside_provider.template.dart' as _ref1;
import 'package:angular/src/core/linker/app_view.dart';
import 'beta_component.dart' as import1;
import 'dart:html' as import2;
import 'package:angular/src/core/render/api.dart';
import 'package:angular/src/core/linker/view_type.dart' as import4;
import 'package:angular/src/core/change_detection/change_detection.dart';
import 'package:angular/src/core/linker/app_view_utils.dart' as import6;
import 'package:angular/src/runtime.dart' as import7;
import 'package:angular/angular.dart';
import 'outside_provider.dart' as import9;

final List<dynamic> styles$BetaComponent = const [];

class ViewBetaComponent0 extends AppView<import1.BetaComponent> {
  import2.Element _el_0;
  import2.Text _text_2;
  var _expr_0;
  static RenderComponentType _renderType;
  ViewBetaComponent0(AppView<dynamic> parentView, int parentIndex) : super(import4.ViewType.component, {}, parentView, parentIndex, ChangeDetectionStrategy.CheckAlways) {
    rootEl = import2.document.createElement('beta-component');
    _renderType ??= import6.appViewUtils.createRenderType((import7.isDevMode ? 'asset:my_angular_dart_project/lib/beta_component.dart' : null), ViewEncapsulation.None, styles$BetaComponent);
    setupComponentType(_renderType);
  }
  @override
  ComponentRef<import1.BetaComponent> build() {
    final _rootEl = rootEl;
    final import2.HtmlElement parentRenderNode = initViewRoot(_rootEl);
    var doc = import2.document;
    _el_0 = createAndAppend(doc, 'h1', parentRenderNode);
    import2.Text _text_1 = import2.Text('Hello ');
    _el_0.append(_text_1);
    _text_2 = import2.Text('');
    _el_0.append(_text_2);
    init(const [], null);
    return null;
  }

  @override
  void detectChangesInternal() {
    final import1.BetaComponent _ctx = ctx;
    final currVal_0 = (_ctx.name ?? '');
    if (import6.checkBinding(_expr_0, currVal_0)) {
      _text_2.text = currVal_0;
      _expr_0 = currVal_0;
    }
  }
}

AppView<import1.BetaComponent> viewFactory_BetaComponent0(AppView<dynamic> parentView, int parentIndex) {
  return ViewBetaComponent0(parentView, parentIndex);
}

final List<dynamic> styles$BetaComponentHost = const [];

class _ViewBetaComponentHost0 extends AppView<import1.BetaComponent> {
  ViewBetaComponent0 _compView_0;
  import1.BetaComponent _BetaComponent_0_5;
  import9.OutsideService __OutsideService_0_6;
  _ViewBetaComponentHost0(AppView<dynamic> parentView, int parentIndex) : super(import4.ViewType.host, {}, parentView, parentIndex, ChangeDetectionStrategy.CheckAlways);
  import9.OutsideService get _OutsideService_0_6 {
    if ((this.__OutsideService_0_6 == null)) {
      (__OutsideService_0_6 = import9.OutsideService());
    }
    return this.__OutsideService_0_6;
  }

  @override
  ComponentRef<import1.BetaComponent> build() {
    _compView_0 = ViewBetaComponent0(this, 0);
    rootEl = _compView_0.rootEl;
    _BetaComponent_0_5 = import1.BetaComponent();
    _compView_0.create(_BetaComponent_0_5, projectableNodes);
    init0(rootEl);
    return ComponentRef(0, this, rootEl, _BetaComponent_0_5);
  }

  @override
  dynamic injectorGetInternal(dynamic token, int nodeIndex, dynamic notFoundResult) {
    if ((identical(token, import9.OutsideService) && (0 == nodeIndex))) {
      return _OutsideService_0_6;
    }
    return notFoundResult;
  }

  @override
  void detectChangesInternal() {
    bool firstCheck = (this.cdState == 0);
    if ((!import6.AppViewUtils.throwOnChanges && firstCheck)) {
      _BetaComponent_0_5.ngOnInit();
    }
    _compView_0.detectChanges();
  }

  @override
  void destroyInternal() {
    _compView_0?.destroy();
  }
}

AppView<import1.BetaComponent> viewFactory_BetaComponentHost0(AppView<dynamic> parentView, int parentIndex) {
  return _ViewBetaComponentHost0(parentView, parentIndex);
}

const ComponentFactory<import1.BetaComponent> _BetaComponentNgFactory = const ComponentFactory('beta-component', viewFactory_BetaComponentHost0);
ComponentFactory<import1.BetaComponent> get BetaComponentNgFactory {
  return _BetaComponentNgFactory;
}

var _visited = false;
void initReflector() {
  if (_visited) {
    return;
  }
  _visited = true;

  _ngRef.registerComponent(BetaComponent, BetaComponentNgFactory);
  _ref0.initReflector();
  _ref1.initReflector();
}
