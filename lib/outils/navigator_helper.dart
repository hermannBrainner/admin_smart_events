import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NavigatorObserverWithOrientation extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute!.settings.arguments is OrientationEcran) {
      _setOrientation(previousRoute.settings.arguments as OrientationEcran);
    } else {
      // Portrait-only is the default option
      _setOrientation(OrientationEcran.PORTRAIT);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // write( route.settings.arguments is OrientationEcran, "didPush didPop");

    if (route.settings.arguments is OrientationEcran) {
      _setOrientation(route.settings.arguments as OrientationEcran);
    } else {
      _setOrientation(OrientationEcran.PORTRAIT);
    }
  }
}

// This function helps to build RouteSettings object for the orientation
RouteSettings rotationSettings(
    RouteSettings settings, OrientationEcran rotation) {
  return RouteSettings(name: settings.name, arguments: rotation);
}

enum OrientationEcran {
  PORTRAIT,
  PAYSAGE,
}

void _setOrientation(OrientationEcran orientation) {
  List<DeviceOrientation> orientations;
  switch (orientation) {
    case OrientationEcran.PORTRAIT:
      //  write( "PORTRAIT", "didPop_setOrientation");
      orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
      break;
    case OrientationEcran.PAYSAGE:
      //   write( "PAYSAGE", "didPop_setOrientation");
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(orientations);
}
