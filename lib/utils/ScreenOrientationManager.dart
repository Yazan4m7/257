import 'package:app/screens/media_player_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print("[NavigatorObserver] : csuper.didPush");
    if (route is MaterialPageRoute) {
      print("[NavigatorObserver] : route is MaterialPageRoute");
      final currentScreen = route.builder;
      // Check if the current screen is of type BetterPlayerPage
      if (currentScreen is BetterPlayerPage) {
          print("[NavigatorObserver] : currentScreen is BetterPlayerPage");
        // Set landscape mode for BetterPlayerPage
        OrientationManager.setLandscapeMode();
      } else {
         print("[NavigatorObserver] : currentScreen is NOT BetterPlayerPage");
        // Revert to portrait mode for other screens
        OrientationManager.setPortraitMode();
      }
    }
    print("[NavigatorObserver] : END OF didPush");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print("[NavigatorObserver] : super.didPop");
    if (previousRoute is MaterialPageRoute) {
       print("[NavigatorObserver] :previousRoute is MaterialPageRoute");
      final previousScreen = previousRoute.builder;
      // Check if the previous screen is of type BetterPlayerPage
      if (previousScreen is BetterPlayerPage) {
         print("[NavigatorObserver] : previousScreen is BetterPlayerPage");
        // Ensure portrait mode when navigating back from BetterPlayerPage
        OrientationManager.setPortraitMode();
      }

    }
     print("[NavigatorObserver] : END OF didPop");
  }
}


class OrientationManager {
  static void setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  static void setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}