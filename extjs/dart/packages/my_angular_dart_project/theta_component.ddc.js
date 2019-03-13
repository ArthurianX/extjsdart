define(['dart_sdk'], function(dart_sdk) {
  'use strict';
  const core = dart_sdk.core;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const _root = Object.create(null);
  const theta_component = Object.create(_root);
  theta_component.ThetaComponent = class ThetaComponent extends core.Object {
    get name() {
      return this[name];
    }
    set name(value) {
      this[name] = value;
    }
  };
  (theta_component.ThetaComponent.new = function() {
    this[name] = "Angular 3";
  }).prototype = theta_component.ThetaComponent.prototype;
  dart.addTypeTests(theta_component.ThetaComponent);
  const name = Symbol("ThetaComponent.name");
  dart.setFieldSignature(theta_component.ThetaComponent, () => ({
    __proto__: dart.getFields(theta_component.ThetaComponent.__proto__),
    name: dart.fieldType(core.String)
  }));
  dart.trackLibraries("packages/my_angular_dart_project/theta_component.ddc", {
    "package:my_angular_dart_project/theta_component.dart": theta_component
  }, '{"version":3,"sourceRoot":"","sources":["theta_component.dart"],"names":[],"mappings":";;;;;;;;IAOM;;;;;;;;cAAI,GAAG;EACb","file":"theta_component.ddc.js"}');
  // Exports:
  return {
    theta_component: theta_component
  };
});

//# sourceMappingURL=theta_component.ddc.js.map
