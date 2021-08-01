import 'package:audioplayers/audioplayers.dart';

class MediaPlayer {
  /// An AudioPlayer Widget that can be reused for different components
  ///
  /// To add more features for a component, inherit and override this class
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final _audioCache = AudioCache(fixedPlayer: _audioPlayer);

  static Future playAudio(String path) async {
    // stop currently playing audios, if any
    await stopAudio();
    // play the audio from the given path
    await _audioCache.play(path);
  }

  static stopAudio() {
    // stop a currently playing audio
    _audioPlayer.stop();
  }
}
