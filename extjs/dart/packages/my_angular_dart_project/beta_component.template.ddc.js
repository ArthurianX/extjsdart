define(['dart_sdk', 'packages/angular/src/core/linker/view_type', 'packages/angular/src/core/change_detection/change_detection', 'packages/angular/src/bootstrap/modules', 'packages/my_angular_dart_project/beta_component', 'packages/my_angular_dart_project/outside_provider', 'packages/angular/angular.template', 'packages/my_angular_dart_project/outside_provider.template'], function(dart_sdk, view_type, change_detection, modules, beta_component, outside_provider, angular, outside_provider$) {
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
  const beta_component$ = beta_component.beta_component;
  const outside_provider$0 = outside_provider.outside_provider;
  const angular$46template = angular.angular$46template;
  const outside_provider$46template = outside_provider$.outside_provider$46template;
  const _root = Object.create(null);
  const beta_component$46template = Object.create(_root);
  const $createElement = dartx.createElement;
  const $append = dartx.append;
  const $text = dartx.text;
  let IdentityMapOfString$dynamic = () => (IdentityMapOfString$dynamic = dart.constFn(_js_helper.IdentityMap$(core.String, dart.dynamic)))();
  let ComponentRefOfBetaComponent = () => (ComponentRefOfBetaComponent = dart.constFn(src__core__linker__component_factory.ComponentRef$(beta_component$.BetaComponent)))();
  let AppViewOfBetaComponent = () => (AppViewOfBetaComponent = dart.constFn(src__core__linker__app_view.AppView$(beta_component$.BetaComponent)))();
  let AppViewAndintToAppViewOfBetaComponent = () => (AppViewAndintToAppViewOfBetaComponent = dart.constFn(dart.fnType(AppViewOfBetaComponent(), [src__core__linker__app_view.AppView, core.int])))();
  let ComponentFactoryOfBetaComponent = () => (ComponentFactoryOfBetaComponent = dart.constFn(src__core__linker__component_factory.ComponentFactory$(beta_component$.BetaComponent)))();
  dart.defineLazy(beta_component$46template, {
    /*beta_component$46template.styles$BetaComponent*/get styles$BetaComponent() {
      return dart.constList([], dart.dynamic);
    }
  });
  const _el_0 = Symbol('_el_0');
  const _text_2 = Symbol('_text_2');
  const _expr_0 = Symbol('_expr_0');
  let const$;
  beta_component$46template.ViewBetaComponent0 = class ViewBetaComponent0 extends src__core__linker__app_view.AppView$(beta_component$.BetaComponent) {
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
  (beta_component$46template.ViewBetaComponent0.new = function(parentView, parentIndex) {
    this[_el_0] = null;
    this[_text_2] = null;
    this[_expr_0] = null;
    beta_component$46template.ViewBetaComponent0.__proto__.new.call(this, src__core__linker__view_type.ViewType.component, new (IdentityMapOfString$dynamic()).new(), parentView, parentIndex, src__core__change_detection__constants.ChangeDetectionStrategy.CheckAlways);
    this.rootEl = html.HtmlElement._check(html.document[$createElement]("beta-component"));
    let t = beta_component$46template.ViewBetaComponent0._renderType;
    t == null ? beta_component$46template.ViewBetaComponent0._renderType = src__core__linker__app_view_utils.appViewUtils.createRenderType(dart.test(src__runtime__optimizations.isDevMode) ? "asset:my_angular_dart_project/lib/beta_component.dart" : null, src__core__metadata__view.ViewEncapsulation.None, beta_component$46template.styles$BetaComponent) : t;
    this.setupComponentType(beta_component$46template.ViewBetaComponent0._renderType);
  }).prototype = beta_component$46template.ViewBetaComponent0.prototype;
  dart.addTypeTests(beta_component$46template.ViewBetaComponent0);
  dart.setMethodSignature(beta_component$46template.ViewBetaComponent0, () => ({
    __proto__: dart.getMethods(beta_component$46template.ViewBetaComponent0.__proto__),
    build: dart.fnType(src__core__linker__component_factory.ComponentRef$(beta_component$.BetaComponent), []),
    detectChangesInternal: dart.fnType(dart.void, [])
  }));
  dart.setFieldSignature(beta_component$46template.ViewBetaComponent0, () => ({
    __proto__: dart.getFields(beta_component$46template.ViewBetaComponent0.__proto__),
    [_el_0]: dart.fieldType(html.Element),
    [_text_2]: dart.fieldType(html.Text),
    [_expr_0]: dart.fieldType(dart.dynamic)
  }));
  dart.defineLazy(beta_component$46template.ViewBetaComponent0, {
    /*beta_component$46template.ViewBetaComponent0._renderType*/get _renderType() {
      return null;
    },
    set _renderType(_) {}
  });
  beta_component$46template.viewFactory_BetaComponent0 = function(parentView, parentIndex) {
    return new beta_component$46template.ViewBetaComponent0.new(parentView, parentIndex);
  };
  dart.defineLazy(beta_component$46template, {
    /*beta_component$46template.styles$BetaComponentHost*/get styles$BetaComponentHost() {
      return dart.constList([], dart.dynamic);
    }
  });
  const _compView_0 = Symbol('_compView_0');
  const _BetaComponent_0_5 = Symbol('_BetaComponent_0_5');
  const __OutsideService_0_6 = Symbol('__OutsideService_0_6');
  const _OutsideService_0_6 = Symbol('_OutsideService_0_6');
  beta_component$46template._ViewBetaComponentHost0 = class _ViewBetaComponentHost0 extends src__core__linker__app_view.AppView$(beta_component$.BetaComponent) {
    get [_OutsideService_0_6]() {
      if (this[__OutsideService_0_6] == null) {
        this[__OutsideService_0_6] = new outside_provider$0.OutsideService.new();
      }
      return this[__OutsideService_0_6];
    }
    build() {
      this[_compView_0] = new beta_component$46template.ViewBetaComponent0.new(this, 0);
      this.rootEl = this[_compView_0].rootEl;
      this[_BetaComponent_0_5] = new beta_component$.BetaComponent.new();
      this[_compView_0].create(this[_BetaComponent_0_5], this.projectableNodes);
      this.init0(this.rootEl);
      return new (ComponentRefOfBetaComponent()).new(0, this, this.rootEl, this[_BetaComponent_0_5]);
    }
    injectorGetInternal(token, nodeIndex, notFoundResult) {
      if (token === dart.wrapType(outside_provider$0.OutsideService) && 0 === nodeIndex) {
        return this[_OutsideService_0_6];
      }
      return notFoundResult;
    }
    detectChangesInternal() {
      let firstCheck = this.cdState === 0;
      if (!dart.test(src__core__linker__app_view_utils.AppViewUtils.throwOnChanges) && firstCheck) {
        this[_BetaComponent_0_5].ngOnInit();
      }
      this[_compView_0].detectChanges();
    }
    destroyInternal() {
      let t = this[_compView_0];
      t == null ? null : t.destroy();
    }
  };
  (beta_component$46template._ViewBetaComponentHost0.new = function(parentView, parentIndex) {
    this[_compView_0] = null;
    this[_BetaComponent_0_5] = null;
    this[__OutsideService_0_6] = null;
    beta_component$46template._ViewBetaComponentHost0.__proto__.new.call(this, src__core__linker__view_type.ViewType.host, new (IdentityMapOfString$dynamic()).new(), parentView, parentIndex, src__core__change_detection__constants.ChangeDetectionStrategy.CheckAlways);
  }).prototype = beta_component$46template._ViewBetaComponentHost0.prototype;
  dart.addTypeTests(beta_component$46template._ViewBetaComponentHost0);
  dart.setMethodSignature(beta_component$46template._ViewBetaComponentHost0, () => ({
    __proto__: dart.getMethods(beta_component$46template._ViewBetaComponentHost0.__proto__),
    build: dart.fnType(src__core__linker__component_factory.ComponentRef$(beta_component$.BetaComponent), []),
    injectorGetInternal: dart.fnType(dart.dynamic, [dart.dynamic, core.int, dart.dynamic]),
    detectChangesInternal: dart.fnType(dart.void, []),
    destroyInternal: dart.fnType(dart.void, [])
  }));
  dart.setGetterSignature(beta_component$46template._ViewBetaComponentHost0, () => ({
    __proto__: dart.getGetters(beta_component$46template._ViewBetaComponentHost0.__proto__),
    [_OutsideService_0_6]: outside_provider$0.OutsideService
  }));
  dart.setFieldSignature(beta_component$46template._ViewBetaComponentHost0, () => ({
    __proto__: dart.getFields(beta_component$46template._ViewBetaComponentHost0.__proto__),
    [_compView_0]: dart.fieldType(beta_component$46template.ViewBetaComponent0),
    [_BetaComponent_0_5]: dart.fieldType(beta_component$.BetaComponent),
    [__OutsideService_0_6]: dart.fieldType(outside_provider$0.OutsideService)
  }));
  beta_component$46template.viewFactory_BetaComponentHost0 = function(parentView, parentIndex) {
    return new beta_component$46template._ViewBetaComponentHost0.new(parentView, parentIndex);
  };
  dart.defineLazy(beta_component$46template, {
    /*beta_component$46template._BetaComponentNgFactory*/get _BetaComponentNgFactory() {
      return dart.const(new (ComponentFactoryOfBetaComponent()).new("beta-component", dart.fn(beta_component$46template.viewFactory_BetaComponentHost0, AppViewAndintToAppViewOfBetaComponent())));
    }
  });
  dart.copyProperties(beta_component$46template, {
    get BetaComponentNgFactory() {
      return beta_component$46template._BetaComponentNgFactory;
    }
  });
  dart.defineLazy(beta_component$46template, {
    /*beta_component$46template._visited*/get _visited() {
      return false;
    },
    set _visited(_) {}
  });
  beta_component$46template.initReflector = function() {
    if (dart.test(beta_component$46template._visited)) {
      return;
    }
    beta_component$46template._visited = true;
    src__di__reflector.registerComponent(dart.wrapType(beta_component$.BetaComponent), beta_component$46template.BetaComponentNgFactory);
    angular$46template.initReflector();
    outside_provider$46template.initReflector();
  };
  dart.trackLibraries("packages/my_angular_dart_project/beta_component.template.ddc", {
    "package:my_angular_dart_project/beta_component.template.dart": beta_component$46template
  }, '{"version":3,"sourceRoot":"","sources":["beta_component.template.dart"],"names":[],"mappings":";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAuBoB,8CAAoB;YAAG;;;;;;;;;AAcvC,UAAM,UAAU,WAAM;AACtB,UAA0B,mBAAmB,iBAAY,CAAC,OAAO;AACjE,UAAI,MAAc,aAAQ;AAC1B,iBAAK,GAAG,2CAAe,CAAC,GAAG,EAAE,MAAM,gBAAgB;AACnD,UAAa,UAAU,aAAY,CAAC;AACpC,iBAAK,SAAO,CAAC,OAAO;AACpB,mBAAO,GAAG,aAAY,CAAC;AACvB,iBAAK,SAAO,CAAC,aAAO;AACpB,eAAI,CAAC,uDAAU;AACf,YAAO;IACT;;AAIE,UAA4B,OAAO,QAAG;AACtC,cAAmB,IAAI,KAAK;UAAtB,4BAA0B;AAChC,oBAAI,AAAQ,8CAAY,CAAC,aAAO,EAAE,SAAS,IAAG;AAC5C,qBAAO,OAAK,GAAG,SAAS;AACxB,qBAAO,GAAG,SAAS;;IAEvB;;+DA3BmB,UAA2B,EAAE,WAAe;IAJ/C,WAAK;IACR,aAAO;IAChB,aAAO;AAEwD,0EAAM,qCAAgB,UAAU,EAAE,2CAAI,UAAU,EAAE,WAAW,EAAE,8DAAuB,YAAY;AACnK,eAAM,2BAAG,AAAQ,aAAQ,gBAAc,CAAC;AACxC,oEAAW;gBAAX,wDAAW,GAAK,AAAQ,8CAAY,iBAAiB,CAAE,UAAQ,qCAAS,IAAG,0DAA0D,MAAO,2CAAiB,KAAK,EAAE,8CAAoB;AACxL,2BAAkB,CAAC,wDAAW;EAChC;;;;;;;;;;;;;;MAL2B,wDAAW;;;;;kEA+BkB,UAA2B,EAAE,WAAe;AACpG,eAAO,gDAAkB,CAAC,UAAU,EAAE,WAAW;EACnD;;MAEoB,kDAAwB;YAAG;;;;;;;;;AAQ3C,UAAK,0BAAyB,IAAI,MAAO;AACvC,QAAC,0BAAoB,OAAG,qCAAsB;;AAEhD,YAAO,2BAAyB;IAClC;;AAIE,uBAAW,OAAG,gDAAkB,CAAC,MAAM;AACvC,iBAAM,GAAG,iBAAW,OAAO;AAC3B,8BAAkB,OAAG,iCAAqB;AAC1C,uBAAW,OAAO,CAAC,wBAAkB,EAAE,qBAAgB;AACvD,gBAAK,CAAC,WAAM;AACZ,iBAAO,mCAAY,CAAC,GAAG,MAAM,WAAM,EAAE,wBAAkB;IACzD;wBAG4B,KAAa,EAAE,SAAa,EAAE,cAAsB;AAC9E,UAAK,AAAU,KAAK,KAAU,gDAAc,IAAM,MAAK,SAAS,EAAI;AAClE,cAAO,0BAAmB;;AAE5B,YAAO,eAAc;IACvB;;AAIE,UAAK,aAAc,YAAY,KAAI;AACnC,qBAAM,8CAAoB,eAAe,KAAI,UAAU,EAAG;AACxD,gCAAkB,SAAS;;AAE7B,uBAAW,cAAc;IAC3B;;AAIE,+BAAW;;IACb;;oEAtCwB,UAA2B,EAAE,WAAe;IAHjD,iBAAW;IACR,wBAAkB;IACjB,0BAAoB;AAC6B,+EAAM,qCAAgB,KAAK,EAAE,2CAAI,UAAU,EAAE,WAAW,EAAE,8DAAuB,YAAY;EAAC;;;;;;;;;;;;;;;;;;;sEAyC1G,UAA2B,EAAE,WAAe;AACxG,eAAO,qDAAuB,CAAC,UAAU,EAAE,WAAW;EACxD;;MAE8C,iDAAuB;YAAG,gBAAM,uCAAgB,CAAC,kBAAkB,0GAA8B;;;;;AAE7I,YAAO,kDAAuB;IAChC;;;MAEI,kCAAQ;YAAG;;;;;AAEb,kBAAI,kCAAQ,GAAE;AACZ;;AAEF,yCAAW;AAEX,IAAO,oCAAiB,CAAC,4CAAa,EAAE,gDAAsB;AAC9D,IAAM,gCAAa;AACnB,IAAM,yCAAa;EACrB","file":"beta_component.template.ddc.js"}');
  // Exports:
  return {
    beta_component$46template: beta_component$46template
  };
});

//# sourceMappingURL=beta_component.template.ddc.js.map
