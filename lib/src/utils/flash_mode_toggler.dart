import 'dart:async';
import 'package:camera/camera.dart';
import 'package:light/light.dart';

enum Intensity { Light, Dark }

class FlashModeToggler {
  static const int frequency = 8;
  static const int threshold = 10;
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
            // print(value);
            if (count > frequency) {
              count = 0;
              print("Average: ${sum / frequency}");
              sink.add(sum / frequency);
              sum = 0;
            } else {
              count++;
              sum += value;
            }
          },
        ),
      )
      .asyncMap<FlashMode>(
          (event) => event < threshold ? FlashMode.torch : FlashMode.off)
      .distinct()
      .asBroadcastStream();

  static StreamSubscription<FlashMode> flashSubscription =
      flashMode.stream.listen(null);

  static final StreamController<FlashMode> flashMode =
      StreamController.broadcast();
}
