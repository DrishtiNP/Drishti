import 'package:camera/camera.dart';
import 'package:drishti/src/utils/flash_mode_toggler.dart';
import 'package:flutter/widgets.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute?.settings.name == '/') {
      print('Pausing Flash Stream');
      FlashModeToggler.flashMode.add(FlashMode.off);
      Future.delayed(
          const Duration(
            seconds: 1,
          ), () {
        FlashModeToggler.flashSubscription.pause();
      });
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.settings.name == '/') {
      print("Reopening Flash Stream");
      FlashModeToggler.flashSubscription.resume();
    }
    super.didPop(route, previousRoute);
  }
}
