// **************************************************************************
// Generator: Instance of 'Compiler'
// **************************************************************************

// ignore_for_file: cancel_subscriptions,constant_identifier_names,duplicate_import,non_constant_identifier_names,library_prefixes,UNUSED_IMPORT,UNUSED_SHOWN_NAME
import 'theta_component.dart';
export 'theta_component.dart';
import 'package:angular/angular.dart';
import 'package:angular/src/di/reflector.dart' as _ngRef;
import 'package:angular/angular.template.dart' as _ref0;
import 'package:angular/src/core/linker/app_view.dart';
import 'theta_component.dart' as import1;
import 'dart:html' as import2;
import 'package:angular/src/core/render/api.dart';
import 'package:angular/src/core/linker/view_type.dart' as import4;
import 'package:angular/src/core/change_detection/change_detection.dart';
import 'package:angular/src/core/linker/app_view_utils.dart' as import6;
import 'package:angular/src/runtime.dart' as import7;
import 'package:angular/angular.dart';

final List<dynamic> styles$ThetaComponent = const [];

class ViewThetaComponent0 extends AppView<import1.ThetaComponent> {
  import2.Element _el_0;
  import2.Text _text_2;
  var _expr_0;
  static RenderComponentType _renderType;
  ViewThetaComponent0(AppView<dynamic> parentView, int parentIndex) : super(import4.ViewType.component, {}, parentView, parentIndex, ChangeDetectionStrategy.CheckAlways) {
    rootEl = import2.document.createElement('theta-component');
    _renderType ??= import6.appViewUtils.createRenderType((import7.isDevMode ? 'asset:my_angular_dart_project/lib/theta_component.dart' : null), ViewEncapsulation.None, styles$ThetaComponent);
    setupComponentType(_renderType);
  }
  @override
  ComponentRef<import1.ThetaComponent> build() {
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
    final import1.ThetaComponent _ctx = ctx;
    final currVal_0 = (_ctx.name ?? '');
    if (import6.checkBinding(_expr_0, currVal_0)) {
      _text_2.text = currVal_0;
      _expr_0 = currVal_0;
    }
  }
}

AppView<import1.ThetaComponent> viewFactory_ThetaComponent0(AppView<dynamic> parentView, int parentIndex) {
  return ViewThetaComponent0(parentView, parentIndex);
}

final List<dynamic> styles$ThetaComponentHost = const [];

class _ViewThetaComponentHost0 extends AppView<import1.ThetaComponent> {
  ViewThetaComponent0 _compView_0;
  import1.ThetaComponent _ThetaComponent_0_5;
  _ViewThetaComponentHost0(AppView<dynamic> parentView, int parentIndex) : super(import4.ViewType.host, {}, parentView, parentIndex, ChangeDetectionStrategy.CheckAlways);
  @override
  ComponentRef<import1.ThetaComponent> build() {
    _compView_0 = ViewThetaComponent0(this, 0);
    rootEl = _compView_0.rootEl;
    _ThetaComponent_0_5 = import1.ThetaComponent();
    _compView_0.create(_ThetaComponent_0_5, projectableNodes);
    init0(rootEl);
    return ComponentRef(0, this, rootEl, _ThetaComponent_0_5);
  }

  @override
  void detectChangesInternal() {
    _compView_0.detectChanges();
  }

  @override
  void destroyInternal() {
    _compView_0?.destroy();
  }
}

AppView<import1.ThetaComponent> viewFactory_ThetaComponentHost0(AppView<dynamic> parentView, int parentIndex) {
  return _ViewThetaComponentHost0(parentView, parentIndex);
}

const ComponentFactory<import1.ThetaComponent> _ThetaComponentNgFactory = const ComponentFactory('theta-component', viewFactory_ThetaComponentHost0);
ComponentFactory<import1.ThetaComponent> get ThetaComponentNgFactory {
  return _ThetaComponentNgFactory;
}

var _visited = false;
void initReflector() {
  if (_visited) {
    return;
  }
  _visited = true;

  _ngRef.registerComponent(ThetaComponent, ThetaComponentNgFactory);
  _ref0.initReflector();
}
