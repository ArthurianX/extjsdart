define(['dart_sdk'], function(dart_sdk) {
  'use strict';
  const core = dart_sdk.core;
  const _js_helper = dart_sdk._js_helper;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const _root = Object.create(null);
  const outside_provider = Object.create(_root);
  outside_provider.OutsideService = class OutsideService extends core.Object {
    static getData() {
      return outside_provider.OutsideService.outsideData;
    }
    static setData(data) {
      outside_provider.OutsideService.outsideData = core.Map._check(data);
    }
  };
  (outside_provider.OutsideService.new = function() {
  }).prototype = outside_provider.OutsideService.prototype;
  dart.addTypeTests(outside_provider.OutsideService);
  dart.defineLazy(outside_provider.OutsideService, {
    /*outside_provider.OutsideService.outsideData*/get outsideData() {
      return new _js_helper.LinkedMap.new();
    },
    set outsideData(_) {}
  });
  dart.trackLibraries("packages/my_angular_dart_project/outside_provider.ddc", {
    "package:my_angular_dart_project/outside_provider.dart": outside_provider
  }, '{"version":3,"sourceRoot":"","sources":["outside_provider.dart"],"names":[],"mappings":";;;;;;;;;;AAMI,YAAO,4CAAW;IACpB;mBACe,IAAI;AACjB,iDAAW,mBAAG,IAAI;IACpB;;;EACF;;;MAPa,2CAAW;YAAG","file":"outside_provider.ddc.js"}');
  // Exports:
  return {
    outside_provider: outside_provider
  };
});

//# sourceMappingURL=outside_provider.ddc.js.map
