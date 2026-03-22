import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart' as ja;

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final ja.AudioPlayer _player = ja.AudioPlayer();
  final _mediaItem = MediaItem(
    id: 'radio_stream',
    title: '90.7 UTY FM Medari',
    artist: 'Hits Tanpa Henti',
  );

  RadioAudioHandler() {
    mediaItem.add(_mediaItem);

    _player.playingStream.listen((playing) {
      _broadcastState();
    });

    _player.processingStateStream.listen((_) {
      _broadcastState();
    });
  }

  AudioProcessingState _mapProcessingState(ja.ProcessingState state) {
    switch (state) {
      case ja.ProcessingState.idle:
        return AudioProcessingState.idle;
      case ja.ProcessingState.loading:
        return AudioProcessingState.loading;
      case ja.ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ja.ProcessingState.ready:
        return AudioProcessingState.ready;
      case ja.ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  void _broadcastState() {
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play, MediaControl.pause, MediaControl.stop],
        processingState: _mapProcessingState(_player.processingState),
        playing: _player.playing,
        updatePosition: _player.position,
      ),
    );
  }

  @override
  Future<void> play() async {
    await _player.setUrl('https://secure.streaming.id/utyfmedari');
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(
      PlaybackState(controls: [], processingState: AudioProcessingState.idle),
    );
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }
}
