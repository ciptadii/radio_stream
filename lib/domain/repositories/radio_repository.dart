import '../entities/radio_station.dart';

abstract class RadioRepository {
  Stream<bool> get playingStream;
  Future<void> play(RadioStation station);
  Future<void> pause();
  Future<void> stop();
  bool get isPlaying;
}
