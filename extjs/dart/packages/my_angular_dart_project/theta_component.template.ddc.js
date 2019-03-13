define(['dart_sdk', 'packages/angular/src/core/linker/view_type', 'packages/angular/src/core/change_detection/change_detection', 'packages/angular/src/bootstrap/modules', 'packages/my_angular_dart_project/theta_component', 'packages/angular/angular.template'], function(dart_sdk, view_type, change_detection, modules, theta_component, angular) {
  'use strict';
  const core = dart_sdk.core;
  const _js_helper = dart_sdk._js_helper;
  const html = dart_sdk.html;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const src__core__linker__view_type = view_type.src__core__linker__view_type;
  const src__core__change_detection__constants = change_detection.src__core__change_detection__constants;
  const src__runtime__optimizations = change_detection.src__runtime__optimizations;
  const src__core__metadata__view = change_detection.src__core__metadata__view;
  const src__di__reflector = change_detection.src__di__reflector;
  const src__core__linker__app_view_utils = modules.src__core__linker__app_view_utils;
  const src__core__linker__app_view = modules.src__core__linker__app_view;
  const src__core__linker__component_factory = modules.src__core__linker__component_factory;
  const theta_component$ = theta_component.theta_component;
  const angular$46template = angular.angular$46template;
  const _root = Object.create(null);
  const theta_component$46template = Object.create(_root);
  const $createElement = dartx.createElement;
  const $append = dartx.append;
  const $text = dartx.text;
  let IdentityMapOfString$dynamic = () => (IdentityMapOfString$dynamic = dart.constFn(_js_helper.IdentityMap$(core.String, dart.dynamic)))();
  let ComponentRefOfThetaComponent = () => (ComponentRefOfThetaComponent = dart.constFn(src__core__linker__component_factory.ComponentRef$(theta_component$.ThetaComponent)))();
  let AppViewOfThetaComponent = () => (AppViewOfThetaComponent = dart.constFn(src__core__linker__app_view.AppView$(theta_component$.ThetaComponent)))();
  let AppViewAndintToAppViewOfThetaComponent = () => (AppViewAndintToAppViewOfThetaComponent = dart.constFn(dart.fnType(AppViewOfThetaComponent(), [src__core__linker__app_view.AppView, core.int])))();
  let ComponentFactoryOfThetaComponent = () => (ComponentFactoryOfThetaComponent = dart.constFn(src__core__linker__component_factory.ComponentFactory$(theta_component$.ThetaComponent)))();
  dart.defineLazy(theta_component$46template, {
    /*theta_component$46template.styles$ThetaComponent*/get styles$ThetaComponent() {
      return dart.constList([], dart.dynamic);
    }
  });
  const _el_0 = Symbol('_el_0');
  const _text_2 = Symbol('_text_2');
  const _expr_0 = Symbol('_expr_0');
  let const$;
  theta_component$46template.ViewThetaComponent0 = class ViewThetaComponent0 extends src__core__linker__app_view.AppView$(theta_component$.ThetaComponent) {
    build() {
      let _rootEl = this.rootEl;
      let parentRenderNode = this.initViewRoot(_rootEl);
      let doc = html.document;
      this[_el_0] = src__core__linker__app_view.createAndAppend(doc, "h1", parentRenderNode);
      let _text_1 = html.Text.new("Hello ");
      this[_el_0][$append](_text_1);
      this[_text_2] = html.Text.new("");
      this[_el_0][$append](this[_text_2]);
      this.init(const$ || (const$ = dart.constList([], dart.dynamic)), null);
      return null;
    }
    detectChangesInternal() {
      let _ctx = this.ctx;
      let l = _ctx.name;
      let currVal_0 = l != null ? l : "";
      if (dart.test(src__core__linker__app_view_utils.checkBinding(this[_expr_0], currVal_0))) {
        this[_text_2][$text] = currVal_0;
        this[_expr_0] = currVal_0;
      }
    }
  };
  (theta_component$46template.ViewThetaComponent0.new = function(parentView, parentIndex) {
    this[_el_0] = null;
    this[_text_2] = null;
    this[_expr_0] = null;
    theta_component$46template.ViewThetaComponent0.__proto__.new.call(this, src__core__linker__view_type.ViewType.component, new (IdentityMapOfString$dynamic()).new(), parentView, parentIndex, src__core__change_detection__constants.ChangeDetectionStrategy.CheckAlways);
    this.rootEl = html.HtmlElement._check(html.document[$createElement]("theta-component"));
    let t = theta_component$46template.ViewThetaComponent0._renderType;
    t == null ? theta_component$46template.ViewThetaComponent0._renderType = src__core__linker__app_view_utils.appViewUtils.createRenderType(dart.test(src__runtime__optimizations.isDevMode) ? "asset:my_angular_dart_project/lib/theta_component.dart" : null, src__core__metadata__view.ViewEncapsulation.None, theta_component$46template.styles$ThetaComponent) : t;
    this.setupComponentType(theta_component$46template.ViewThetaComponent0._renderType);
  }).prototype = theta_component$46template.ViewThetaComponent0.prototype;
  dart.addTypeTests(theta_component$46template.ViewThetaComponent0);
  dart.setMethodSignature(theta_component$46template.ViewThetaComponent0, () => ({
    __proto__: dart.getMethods(theta_component$46template.ViewThetaComponent0.__proto__),
    build: dart.fnType(src__core__linker__component_factory.ComponentRef$(theta_component$.ThetaComponent), []),
    detectChangesInternal: dart.fnType(dart.void, [])
  }));
  dart.setFieldSignature(theta_component$46template.ViewThetaComponent0, () => ({
    __proto__: dart.getFields(theta_component$46template.ViewThetaComponent0.__proto__),
    [_el_0]: dart.fieldType(html.Element),
    [_text_2]: dart.fieldType(html.Text),
    [_expr_0]: dart.fieldType(dart.dynamic)
  }));
  dart.defineLazy(theta_component$46template.ViewThetaComponent0, {
    /*theta_component$46template.ViewThetaComponent0._renderType*/get _renderType() {
      return null;
    },
    set _renderType(_) {}
  });
  theta_component$46template.viewFactory_ThetaComponent0 = function(parentView, parentIndex) {
    return new theta_component$46template.ViewThetaComponent0.new(parentView, parentIndex);
  };
  dart.defineLazy(theta_component$46template, {
    /*theta_component$46template.styles$ThetaComponentHost*/get styles$ThetaComponentHost() {
      return dart.constList([], dart.dynamic);
    }
  });
  const _compView_0 = Symbol('_compView_0');
  const _ThetaComponent_0_5 = Symbol('_ThetaComponent_0_5');
  theta_component$46template._ViewThetaComponentHost0 = class _ViewThetaComponentHost0 extends src__core__linker__app_view.AppView$(theta_component$.ThetaComponent) {
    build() {
      this[_compView_0] = new theta_component$46template.ViewThetaComponent0.new(this, 0);
      this.rootEl = this[_compView_0].rootEl;
      this[_ThetaComponent_0_5] = new theta_component$.ThetaComponent.new();
      this[_compView_0].create(this[_ThetaComponent_0_5], this.projectableNodes);
      this.init0(this.rootEl);
      return new (ComponentRefOfThetaComponent()).new(0, this, this.rootEl, this[_ThetaComponent_0_5]);
    }
    detectChangesInternal() {
      this[_compView_0].detectChanges();
    }
    destroyInternal() {
      let t = this[_compView_0];
      t == null ? null : t.destroy();
    }
  };
  (theta_component$46template._ViewThetaComponentHost0.new = function(parentView, parentIndex) {
    this[_compView_0] = null;
    this[_ThetaComponent_0_5] = null;
    theta_component$46template._ViewThetaComponentHost0.__proto__.new.call(this, src__core__linker__view_type.ViewType.host, new (IdentityMapOfString$dynamic()).new(), parentView, parentIndex, src__core__change_detection__constants.ChangeDetectionStrategy.CheckAlways);
  }).prototype = theta_component$46template._ViewThetaComponentHost0.prototype;
  dart.addTypeTests(theta_component$46template._ViewThetaComponentHost0);
  dart.setMethodSignature(theta_component$46template._ViewThetaComponentHost0, () => ({
    __proto__: dart.getMethods(theta_component$46template._ViewThetaComponentHost0.__proto__),
    build: dart.fnType(src__core__linker__component_factory.ComponentRef$(theta_component$.ThetaComponent), []),
    detectChangesInternal: dart.fnType(dart.void, []),
    destroyInternal: dart.fnType(dart.void, [])
  }));
  dart.setFieldSignature(theta_component$46template._ViewThetaComponentHost0, () => ({
    __proto__: dart.getFields(theta_component$46template._ViewThetaComponentHost0.__proto__),
    [_compView_0]: dart.fieldType(theta_component$46template.ViewThetaComponent0),
    [_ThetaComponent_0_5]: dart.fieldType(theta_component$.ThetaComponent)
  }));
  theta_component$46template.viewFactory_ThetaComponentHost0 = function(parentView, parentIndex) {
    return new theta_component$46template._ViewThetaComponentHost0.new(parentView, parentIndex);
  };
  dart.defineLazy(theta_component$46template, {
    /*theta_component$46template._ThetaComponentNgFactory*/get _ThetaComponentNgFactory() {
      return dart.const(new (ComponentFactoryOfThetaComponent()).new("theta-component", dart.fn(theta_component$46template.viewFactory_ThetaComponentHost0, AppViewAndintToAppViewOfThetaComponent())));
    }
  });
  dart.copyProperties(theta_component$46template, {
    get ThetaComponentNgFactory() {
      return theta_component$46template._ThetaComponentNgFactory;
    }
  });
  dart.defineLazy(theta_component$46template, {
    /*theta_component$46template._visited*/get _visited() {
      return false;
    },
    set _visited(_) {}
  });
  theta_component$46template.initReflector = function() {
    if (dart.test(theta_component$46template._visited)) {
      return;
    }
    theta_component$46template._visited = true;
    src__di__reflector.registerComponent(dart.wrapType(theta_component$.ThetaComponent), theta_component$46template.ThetaComponentNgFactory);
    angular$46template.initReflector();
  };
  dart.trackLibraries("packages/my_angular_dart_project/theta_component.template.ddc", {
    "package:my_angular_dart_project/theta_component.template.dart": theta_component$46template
  }, '{"version":3,"sourceRoot":"","sources":["theta_component.template.dart"],"names":[],"mappings":";;;;;;;;;;;;;;;;;;;;;;;;;;;;MAoBoB,gDAAqB;YAAG;;;;;;;;;AAcxC,UAAM,UAAU,WAAM;AACtB,UAA0B,mBAAmB,iBAAY,CAAC,OAAO;AACjE,UAAI,MAAc,aAAQ;AAC1B,iBAAK,GAAG,2CAAe,CAAC,GAAG,EAAE,MAAM,gBAAgB;AACnD,UAAa,UAAU,aAAY,CAAC;AACpC,iBAAK,SAAO,CAAC,OAAO;AACpB,mBAAO,GAAG,aAAY,CAAC;AACvB,iBAAK,SAAO,CAAC,aAAO;AACpB,eAAI,CAAC,uDAAU;AACf,YAAO;IACT;;AAIE,UAA6B,OAAO,QAAG;AACvC,cAAmB,IAAI,KAAK;UAAtB,4BAA0B;AAChC,oBAAI,AAAQ,8CAAY,CAAC,aAAO,EAAE,SAAS,IAAG;AAC5C,qBAAO,OAAK,GAAG,SAAS;AACxB,qBAAO,GAAG,SAAS;;IAEvB;;iEA3BoB,UAA2B,EAAE,WAAe;IAJhD,WAAK;IACR,aAAO;IAChB,aAAO;AAEyD,4EAAM,qCAAgB,UAAU,EAAE,2CAAI,UAAU,EAAE,WAAW,EAAE,8DAAuB,YAAY;AACpK,eAAM,2BAAG,AAAQ,aAAQ,gBAAc,CAAC;AACxC,sEAAW;gBAAX,0DAAW,GAAK,AAAQ,8CAAY,iBAAiB,CAAE,UAAQ,qCAAS,IAAG,2DAA2D,MAAO,2CAAiB,KAAK,EAAE,gDAAqB;AAC1L,2BAAkB,CAAC,0DAAW;EAChC;;;;;;;;;;;;;;MAL2B,0DAAW;;;;;oEA+BoB,UAA2B,EAAE,WAAe;AACtG,eAAO,kDAAmB,CAAC,UAAU,EAAE,WAAW;EACpD;;MAEoB,oDAAyB;YAAG;;;;;;;AAQ5C,uBAAW,OAAG,kDAAmB,CAAC,MAAM;AACxC,iBAAM,GAAG,iBAAW,OAAO;AAC3B,+BAAmB,OAAG,mCAAsB;AAC5C,uBAAW,OAAO,CAAC,yBAAmB,EAAE,qBAAgB;AACxD,gBAAK,CAAC,WAAM;AACZ,iBAAO,oCAAY,CAAC,GAAG,MAAM,WAAM,EAAE,yBAAmB;IAC1D;;AAIE,uBAAW,cAAc;IAC3B;;AAIE,+BAAW;;IACb;;sEAnByB,UAA2B,EAAE,WAAe;IAFjD,iBAAW;IACR,yBAAmB;AAC+B,iFAAM,qCAAgB,KAAK,EAAE,2CAAI,UAAU,EAAE,WAAW,EAAE,8DAAuB,YAAY;EAAC;;;;;;;;;;;;;wEAsBzG,UAA2B,EAAE,WAAe;AAC1G,eAAO,uDAAwB,CAAC,UAAU,EAAE,WAAW;EACzD;;MAE+C,mDAAwB;YAAG,gBAAM,wCAAgB,CAAC,mBAAmB,6GAA+B;;;;;AAEjJ,YAAO,oDAAwB;IACjC;;;MAEI,mCAAQ;YAAG;;;;;AAEb,kBAAI,mCAAQ,GAAE;AACZ;;AAEF,0CAAW;AAEX,IAAO,oCAAiB,CAAC,8CAAc,EAAE,kDAAuB;AAChE,IAAM,gCAAa;EACrB","file":"theta_component.template.ddc.js"}');
  // Exports:
  return {
    theta_component$46template: theta_component$46template
  };
});

//# sourceMappingURL=theta_component.template.ddc.js.map
