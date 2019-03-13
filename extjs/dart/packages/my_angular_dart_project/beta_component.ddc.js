define(['dart_sdk', 'packages/my_angular_dart_project/outside_provider', 'packages/angular/src/core/change_detection/change_detection'], function(dart_sdk, outside_provider, change_detection) {
  'use strict';
  const core = dart_sdk.core;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const outside_provider$ = outside_provider.outside_provider;
  const src__core__metadata__lifecycle_hooks = change_detection.src__core__metadata__lifecycle_hooks;
  const _root = Object.create(null);
  const beta_component = Object.create(_root);
  beta_component.BetaComponent = class BetaComponent extends core.Object {
    get name() {
      return this[name];
    }
    set name(value) {
      this[name] = value;
    }
    ngOnInit() {
      core.print("OutsideService.getData() - Inside Angular Flow");
      core.print(outside_provider$.OutsideService.getData());
    }
  };
  (beta_component.BetaComponent.new = function() {
    this[name] = "Angular 2";
  }).prototype = beta_component.BetaComponent.prototype;
  dart.addTypeTests(beta_component.BetaComponent);
  const name = Symbol("BetaComponent.name");
  beta_component.BetaComponent[dart.implements] = () => [src__core__metadata__lifecycle_hooks.OnInit];
  dart.setMethodSignature(beta_component.BetaComponent, () => ({
    __proto__: dart.getMethods(beta_component.BetaComponent.__proto__),
    ngOnInit: dart.fnType(dart.void, [])
  }));
  dart.setFieldSignature(beta_component.BetaComponent, () => ({
    __proto__: dart.getFields(beta_component.BetaComponent.__proto__),
    name: dart.fieldType(core.String)
  }));
  dart.trackLibraries("packages/my_angular_dart_project/beta_component.ddc", {
    "package:my_angular_dart_project/beta_component.dart": beta_component
  }, '{"version":3,"sourceRoot":"","sources":["beta_component.dart"],"names":[],"mappings":";;;;;;;;;;IAWM;;;;;;;AAGF,gBAAK,CAAC;AACN,gBAAK,CAAC,gCAAc,QAAQ;IAC9B;;;IALI,UAAI,GAAG;EAMb","file":"beta_component.ddc.js"}');
  // Exports:
  return {
    beta_component: beta_component
  };
});

//# sourceMappingURL=beta_component.ddc.js.map
