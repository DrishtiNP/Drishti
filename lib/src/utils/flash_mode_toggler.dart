import 'dart:async';
import 'package:camera/camera.dart';
import 'package:light/light.dart';

enum Intensity { Light, Dark }

class FlashModeToggler {
  static int count = 0;
  static int sum = 0;
  static FlashModeToggler? _instance;
  FlashModeToggler._internal() {
    flashModeStream.listen((event) {
      flashMode.add(event);
    });
  }
  static FlashModeToggler get initialize =>
      _instance ??= FlashModeToggler._internal();

  static final Light _light = Light();

  static final Stream<FlashMode> flashModeStream = _light.lightSensorStream
      .transform(
        StreamTransformer.fromHandlers(
          handleData: (int value, EventSink sink) {
            print(value);
            print(count);
            if (count > 10) {
              count = 0;
              print("Average: ${sum / 10}");
              sink.add(sum / 10);
              sum = 0;
            } else {
              count++;
              sum = sum + value;
            }
          },
        ),
      )
      .asyncMap<FlashMode>(
          (event) => event < 10 ? FlashMode.torch : FlashMode.off)
      .distinct()
      .asBroadcastStream();

  static StreamSubscription<FlashMode> flashSubscription =
      flashMode.stream.listen(null);

  static final StreamController<FlashMode> flashMode =
      StreamController.broadcast();
}
