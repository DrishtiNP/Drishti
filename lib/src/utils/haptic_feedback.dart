import 'package:flutter_vibrate/flutter_vibrate.dart';

class HapticFeedback{
  static bool canVibrate = false;

  /// makes sure whether vibration is supported or not
  /// this function runs only once preventing method call from being
  /// called again and again.
  static Future<void> ensureInitialized() async{
      canVibrate = await Vibrate.canVibrate;
  }
}