define(['dart_sdk', 'packages/my_angular_dart_project/outside_provider', 'packages/my_angular_dart_project/app_component.template', 'packages/my_angular_dart_project/app_component', 'packages/angular/src/bootstrap/modules', 'packages/my_angular_dart_project/beta_component.template', 'packages/my_angular_dart_project/beta_component', 'packages/my_angular_dart_project/theta_component.template', 'packages/my_angular_dart_project/theta_component'], function(dart_sdk, outside_provider, app_component, app_component$, modules, beta_component, beta_component$, theta_component, theta_component$) {
  'use strict';
  const core = dart_sdk.core;
  const html = dart_sdk.html;
  const convert = dart_sdk.convert;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const outside_provider$ = outside_provider.outside_provider;
  const app_component$46template = app_component.app_component$46template;
  const app_component$0 = app_component$.app_component;
  const src__bootstrap__run = modules.src__bootstrap__run;
  const beta_component$46template = beta_component.beta_component$46template;
  const beta_component$0 = beta_component$.beta_component;
  const theta_component$46template = theta_component.theta_component$46template;
  const theta_component$0 = theta_component$.theta_component;
  const _root = Object.create(null);
  const main = Object.create(_root);
  const $_get = dartx._get;
  const $attributes = dartx.attributes;
  const $on = dartx.on;
  const $detail = dartx.detail;
  let EventTodynamic = () => (EventTodynamic = dart.constFn(dart.fnType(dart.dynamic, [html.Event])))();
  main.main = function() {
    core.print(html.document.querySelector("beta-component")[$attributes][$_get]("initialdata"));
    let data = convert.jsonDecode(html.document.querySelector("beta-component")[$attributes][$_get]("initialdata"));
    outside_provider$.OutsideService.setData(data);
    html.window[$on]._get("message").listen(dart.fn(main._startSpecificAppOrModule, EventTodynamic()));
  };
  main._startSpecificAppOrModule = function(event) {
    core.print("EVENT");
    core.print(event);
    core.print(html.CustomEvent.as(event)[$detail]);
    if (html.CustomEvent.as(event)[$detail] != null) {
      switch (dart.dindex(html.CustomEvent.as(event)[$detail], "component")) {
        case "component1":
        {
          src__bootstrap__run.runApp(app_component$0.AppComponent, app_component$46template.AppComponentNgFactory);
          outside_provider$.OutsideService.setData(html.CustomEvent.as(event)[$detail]);
          break;
        }
        case "component2":
        {
          src__bootstrap__run.runApp(beta_component$0.BetaComponent, beta_component$46template.BetaComponentNgFactory);
          outside_provider$.OutsideService.setData(html.CustomEvent.as(event)[$detail]);
          break;
        }
        case "component3":
        {
          src__bootstrap__run.runApp(theta_component$0.ThetaComponent, theta_component$46template.ThetaComponentNgFactory);
          outside_provider$.OutsideService.setData(html.CustomEvent.as(event)[$detail]);
          break;
        }
      }
    } else {
      return false;
    }
  };
  dart.trackLibraries("web/main.ddc", {
    "main.dart": main
  }, '{"version":3,"sourceRoot":"","sources":["main.dart"],"names":[],"mappings":";;;;;;;;;;;;;;;;;;;;;;;AAWE,cAAK,CAAC,aAAQ,cAAc,CAAC,8BAA4B,QAAC;AAM1D,QAAI,OAAO,kBAAU,CAAC,aAAQ,cAAc,CAAC,8BAA4B,QAAC;AAE1E,oCAAc,QAAQ,CAAC,IAAI;AAM3B,eAAM,KAAG,MAAC,iBAAiB,CAAC,yDAAyB;EAKvD;4CAE0B,KAAW;AACnC,cAAK,CAAC;AACN,cAAK,CAAC,KAAK;AACX,cAAK,qBAAE,KAAK,UAAuB;AACnC,QAAI,oBAAC,KAAK,UAAuB,IAAI,MAAM;AAKzC,cAAQ,gCAAC,KAAK,UAAuB,EAAC;YAC/B;;AACH,oCAAM,+BAAI,8CAAqB;AAC/B,0CAAc,QAAQ,qBAAE,KAAK,UAAuB;AACtD;;YACK;;AACH,oCAAM,iCAAI,gDAAsB;AAChC,0CAAc,QAAQ,qBAAE,KAAK,UAAuB;AACtD;;YACK;;AACH,oCAAM,mCAAI,kDAAuB;AACjC,0CAAc,QAAQ,qBAAE,KAAK,UAAuB;AACtD;;;WAGG;AACL,YAAO;;EAEX","file":"main.ddc.js"}');
  // Exports:
  return {
    main: main
  };
});

//# sourceMappingURL=main.ddc.js.map
