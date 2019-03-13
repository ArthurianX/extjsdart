define(['dart_sdk', 'packages/my_angular_dart_project/outside_provider', 'packages/angular/src/core/change_detection/change_detection', 'packages/angular/angular.template'], function(dart_sdk, outside_provider, change_detection, angular) {
  'use strict';
  const core = dart_sdk.core;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const outside_provider$ = outside_provider.outside_provider;
  const src__di__reflector = change_detection.src__di__reflector;
  const angular$46template = angular.angular$46template;
  const _root = Object.create(null);
  const outside_provider$46template = Object.create(_root);
  let VoidToOutsideService = () => (VoidToOutsideService = dart.constFn(dart.fnType(outside_provider$.OutsideService, [])))();
  dart.defineLazy(outside_provider$46template, {
    /*outside_provider$46template._visited*/get _visited() {
      return false;
    },
    set _visited(_) {}
  });
  outside_provider$46template.initReflector = function() {
    if (dart.test(outside_provider$46template._visited)) {
      return;
    }
    outside_provider$46template._visited = true;
    src__di__reflector.registerFactory(dart.wrapType(outside_provider$.OutsideService), dart.fn(() => new outside_provider$.OutsideService.new(), VoidToOutsideService()));
    angular$46template.initReflector();
  };
  dart.trackLibraries("packages/my_angular_dart_project/outside_provider.template.ddc", {
    "package:my_angular_dart_project/outside_provider.template.dart": outside_provider$46template
  }, '{"version":3,"sourceRoot":"","sources":["outside_provider.template.dart"],"names":[],"mappings":";;;;;;;;;;;;MAWI,oCAAQ;YAAG;;;;;AAEb,kBAAI,oCAAQ,GAAE;AACZ;;AAEF,2CAAW;AAEX,IAAO,kCAAe,CAAC,+CAAc,EAAE,kBAAM,oCAAc;AAC3D,IAAM,gCAAa;EACrB","file":"outside_provider.template.ddc.js"}');
  // Exports:
  return {
    outside_provider$46template: outside_provider$46template
  };
});

//# sourceMappingURL=outside_provider.template.ddc.js.map
