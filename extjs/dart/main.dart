import 'dart:async';

import 'package:angular/angular.dart';
import "dart:html";
import "dart:convert";
import 'package:my_angular_dart_project/app_component.template.dart' as ng;
import 'package:my_angular_dart_project/beta_component.template.dart' as ng;
import 'package:my_angular_dart_project/theta_component.template.dart' as ng;
import 'package:my_angular_dart_project/outside_provider.dart';

void main() {
  print(document.querySelector('beta-component').attributes['initialdata']);

  /// If we have data on the components html themselves (before bootstrapping),
  /// we read it here and send it inside a service, thus becoming available in
  /// the AngularDart app.
  // Read the data before the element is replaced.
  var data = jsonDecode(document.querySelector('beta-component').attributes['initialdata']);
  // Set the data in the service so it can be read after application bootstrap
  OutsideService.setData(data);


  // TODO: MARIUS
  /// We are listening for postMessage events received from parent windows
  /// [the assumption is that this file is being open in an iframe]
  window.on["message"].listen(_startSpecificAppOrModule);

//  Timer timer = new Timer(new Duration(seconds: 5), () {
//    document.dispatchEvent(new CustomEvent('message', {detail: {component: 'component2', sessionData: '', parameters: '', payload: ''}}));
//  });
}

_startSpecificAppOrModule(Event event) {
  print('EVENT');
  print(event);
  print((event as CustomEvent).detail);
  if ((event as CustomEvent).detail != null) {

    // TODO: MARIUS
    /// Bootstrap whatever AngularDart app we need based on the postMessage information
    /// We can send in session details, parameters, payload, etc.
    switch ((event as CustomEvent).detail['component']) {
      case 'component1':
        runApp(ng.AppComponentNgFactory);
        OutsideService.setData((event as CustomEvent).detail);
      break;
      case 'component2':
        runApp(ng.BetaComponentNgFactory);
        OutsideService.setData((event as CustomEvent).detail);
      break;
      case 'component3':
        runApp(ng.ThetaComponentNgFactory);
        OutsideService.setData((event as CustomEvent).detail);
      break;
    }

  } else {
    return false;
  }
}

