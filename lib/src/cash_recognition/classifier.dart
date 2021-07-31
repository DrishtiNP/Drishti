import 'package:drishti/src/utils/haptic_feedback.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';
import 'package:drishti/src/utils/media_player.dart';
import 'package:drishti/src/cash_recognition/models/note_model.dart';
import 'package:drishti/src/db/database_helper.dart';

String audiofile = "cash_recognition/audio/nrs_audio/";
String _modelPath = "assets/cash_recognition/models/nrs_model/model.tflite";
String _labelPath = "assets/cash_recognition/models/nrs_model/labels.txt";

Future<void> classifyImage(String imagePath) async {
  /// Classify the given image
  // load the tfltie model
  await Tflite.loadModel(model: _modelPath, labels: _labelPath);
  // Run the model on image
  // High threshold for better accuracy
  List<dynamic>? output = await (Tflite.runModelOnImage(
      path: imagePath,
      numResults: 2,
      threshold: 0.99,
      imageMean: 117.0,
      imageStd: 1.0,
      asynch: true));
  // Add classified note to database and play the corresponding audio feedback
  if (output != null && output.isNotEmpty) {
    String result = output[0]["label"];
    // print(result + ' ' + output[0]["confidence"].toString());
    String note = result.substring(2);
    Note noteObj = Note(label: note);
    await DatabaseHelper.instance.insert(noteObj);
    playAudio(note);
    if(HapticFeedback.canVibrate){
      Vibrate.feedback(FeedbackType.success);
    }
  }
  // else play [wrong.mp3]
  else {
    await MediaPlayer.playAudio(audiofile + 'wrong.mp3');
    if(HapticFeedback.canVibrate){
      Vibrate.feedback(FeedbackType.error);
    }
  }
}

Future<void> playAudio(String note) async {
  // play an audio feedback corresponding the classified note
  await MediaPlayer.playAudio(audiofile + note + '.mp3');
}
