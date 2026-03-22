import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/radio_station.dart';

class RadioViewModel extends ChangeNotifier {
  final AudioHandler _audioHandler;
  final VolumeController _volumeController = VolumeController();

  RadioStation _currentStation;
  bool _isBuffering = false;
  String? _errorMessage;
  double _volume = 1.0;
  StreamSubscription<PlaybackState>? _playbackSubscription;

  RadioViewModel({required AudioHandler audioHandler})
    : _audioHandler = audioHandler,
      _currentStation = const RadioStation(
        name: AppConstants.stationName,
        description: AppConstants.stationDescription,
        streamUrl: AppConstants.streamUrl,
      ) {
    _initVolume();
    _listenToPlaybackState();
  }

  RadioStation get currentStation => _currentStation;
  bool get isPlaying => _currentStation.isPlaying;
  bool get isBuffering => _isBuffering;
  String? get errorMessage => _errorMessage;
  double get volume => _volume;

  void _initVolume() async {
    try {
      _volume = await _volumeController.getVolume();
      notifyListeners();
    } catch (_) {
      _volume = 1.0;
    }
  }

  void _listenToPlaybackState() {
    _playbackSubscription = _audioHandler.playbackState.listen((playbackState) {
      _currentStation = _currentStation.copyWith(
        isPlaying: playbackState.playing,
      );
      _isBuffering =
          playbackState.processingState == AudioProcessingState.loading ||
          playbackState.processingState == AudioProcessingState.buffering;
      notifyListeners();
    });
  }

  Future<void> togglePlayPause() async {
    if (_currentStation.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> play() async {
    _errorMessage = null;
    try {
      await _audioHandler.play();
    } catch (e) {
      _errorMessage = 'Failed to play stream: $e';
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioHandler.pause();
    } catch (e) {
      _errorMessage = 'Failed to pause: $e';
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _audioHandler.stop();
    } catch (e) {
      _errorMessage = 'Failed to stop: $e';
      notifyListeners();
    }
  }

  Future<void> setVolume(double value) async {
    _volumeController.setVolume(value);
    _volume = value;
    notifyListeners();
  }

  void setStation(RadioStation station) {
    _currentStation = station;
    notifyListeners();
  }

  @override
  void dispose() {
    _playbackSubscription?.cancel();
    super.dispose();
  }
}
