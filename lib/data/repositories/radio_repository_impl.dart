import 'package:just_audio/just_audio.dart';
import '../../domain/entities/radio_station.dart';
import '../../domain/repositories/radio_repository.dart';

class RadioRepositoryImpl implements RadioRepository {
  final AudioPlayer _audioPlayer;

  RadioRepositoryImpl(this._audioPlayer);

  @override
  bool get isPlaying => _audioPlayer.playing;

  @override
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  @override
  Future<void> play(RadioStation station) async {
    await _audioPlayer.setUrl(station.streamUrl);
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
