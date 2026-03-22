import '../entities/radio_station.dart';
import '../repositories/radio_repository.dart';

class PlayRadioUseCase {
  final RadioRepository _repository;

  PlayRadioUseCase(this._repository);

  Future<void> call(RadioStation station) => _repository.play(station);
}

class PauseRadioUseCase {
  final RadioRepository _repository;

  PauseRadioUseCase(this._repository);

  Future<void> call() => _repository.pause();
}

class StopRadioUseCase {
  final RadioRepository _repository;

  StopRadioUseCase(this._repository);

  Future<void> call() => _repository.stop();
}

class GetPlayingStatusUseCase {
  final RadioRepository _repository;

  GetPlayingStatusUseCase(this._repository);

  Stream<bool> call() => _repository.playingStream;
}
