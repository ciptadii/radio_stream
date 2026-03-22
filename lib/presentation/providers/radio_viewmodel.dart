import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/radio_station.dart';

class RadioViewModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer;

  RadioStation _currentStation;
  bool _isBuffering = false;
  String? _errorMessage;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<ProcessingState>? _processingSubscription;

  RadioViewModel({AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? AudioPlayer(),
      _currentStation = const RadioStation(
        name: 'Radio Stream',
        streamUrl: AppConstants.streamUrl,
      ) {
    _listenToPlayingStatus();
    _listenToProcessingState();
  }

  RadioStation get currentStation => _currentStation;
  bool get isPlaying => _currentStation.isPlaying;
  bool get isBuffering => _isBuffering;
  String? get errorMessage => _errorMessage;

  void _listenToPlayingStatus() {
    _playingSubscription = _audioPlayer.playingStream.listen((playing) {
      _currentStation = _currentStation.copyWith(isPlaying: playing);
      notifyListeners();
    });
  }

  void _listenToProcessingState() {
    _processingSubscription = _audioPlayer.processingStateStream.listen((
      state,
    ) {
      _isBuffering =
          state == ProcessingState.loading ||
          state == ProcessingState.buffering;
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
      await _audioPlayer.setUrl(_currentStation.streamUrl);
      await _audioPlayer.play();
    } catch (e) {
      _errorMessage = 'Failed to play stream: $e';
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _errorMessage = 'Failed to pause: $e';
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      _errorMessage = 'Failed to stop: $e';
      notifyListeners();
    }
  }

  void setStation(RadioStation station) {
    _currentStation = station;
    notifyListeners();
  }

  @override
  void dispose() {
    _playingSubscription?.cancel();
    _processingSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
