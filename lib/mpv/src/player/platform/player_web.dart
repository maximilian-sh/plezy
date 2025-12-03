import 'dart:async';
import '../../models/audio_device.dart';
import '../../models/audio_track.dart';
import '../../models/media.dart';
import '../../models/player_log.dart';
import '../player_state.dart';
import '../player_streams.dart';
import '../../models/subtitle_track.dart';
import '../../models/track_selection.dart';
import '../../models/tracks.dart';
import '../player.dart';

import 'package:video_player/video_player.dart';

class PlayerWeb implements Player {
  PlayerState _state = const PlayerState();
  VideoPlayerController? _controller;

  @override
  PlayerState get state => _state;

  late final PlayerStreams _streams;

  @override
  PlayerStreams get streams => _streams;

  @override
  int? get textureId => null; // Not used for web

  // Expose controller for Video widget
  VideoPlayerController? get controller => _controller;

  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<bool>.broadcast();
  final _bufferingController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _bufferController = StreamController<Duration>.broadcast();
  final _volumeController = StreamController<double>.broadcast();
  final _rateController = StreamController<double>.broadcast();
  final _tracksController = StreamController<Tracks>.broadcast();
  final _trackController = StreamController<TrackSelection>.broadcast();
  final _logController = StreamController<PlayerLog>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _audioDeviceController = StreamController<AudioDevice>.broadcast();
  final _audioDevicesController =
      StreamController<List<AudioDevice>>.broadcast();

  PlayerWeb() {
    _streams = PlayerStreams(
      playing: _playingController.stream,
      completed: _completedController.stream,
      buffering: _bufferingController.stream,
      position: _positionController.stream,
      duration: _durationController.stream,
      buffer: _bufferController.stream,
      volume: _volumeController.stream,
      rate: _rateController.stream,
      tracks: _tracksController.stream,
      track: _trackController.stream,
      log: _logController.stream,
      error: _errorController.stream,
      audioDevice: _audioDeviceController.stream,
      audioDevices: _audioDevicesController.stream,
    );
  }

  @override
  Future<void> open(Media media, {bool play = true}) async {
    print('PlayerWeb: open ${media.uri}');

    // Dispose previous controller if any
    await _controller?.dispose();
    _controller = null;

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(media.uri));
      await _controller!.initialize();

      // Set initial duration
      final duration = _controller!.value.duration;
      _state = _state.copyWith(duration: duration);
      _durationController.add(duration);

      // Ensure volume is set (default to 1.0/100%)
      // await setVolume(100.0); // User requested to remove this

      // Listen to controller updates
      _controller!.addListener(_onControllerUpdate);

      if (media.start != null) {
        print('PlayerWeb: Initial seek to ${media.start}');
        await seek(media.start!);
      }

      if (play) {
        await this.play();
      }

      print('PlayerWeb: Media opened successfully');
      // Emit empty tracks to satisfy listeners
      _tracksController.add(const Tracks(audio: [], subtitle: []));
    } catch (e) {
      print('PlayerWeb: Error opening media: $e');
      // Emit empty tracks to satisfy listeners
      _tracksController.add(const Tracks(audio: [], subtitle: []));
      _errorController.add(e.toString());
    }
  }

  void _onControllerUpdate() {
    if (_controller == null) return;

    final value = _controller!.value;

    // Update playing state
    if (_state.playing != value.isPlaying) {
      _state = _state.copyWith(playing: value.isPlaying);
      _playingController.add(value.isPlaying);
    }

    // Update position
    if (_state.position != value.position) {
      _state = _state.copyWith(position: value.position);
      _positionController.add(value.position);
    }

    // Update buffering
    if (_state.buffering != value.isBuffering) {
      _state = _state.copyWith(buffering: value.isBuffering);
      _bufferingController.add(value.isBuffering);
    }

    // Update completed
    if (value.isCompleted) {
      _state = _state.copyWith(completed: true);
      _completedController.add(true);
    }

    // Update buffer (buffered regions)
    if (value.buffered.isNotEmpty) {
      final bufferEnd = value.buffered.last.end;
      if (_state.buffer != bufferEnd) {
        _state = _state.copyWith(buffer: bufferEnd);
        _bufferController.add(bufferEnd);
      }
    }
  }

  @override
  Future<void> play() async {
    print('PlayerWeb: play() called');
    await _controller?.play();
  }

  @override
  Future<void> pause() async {
    print('PlayerWeb: pause() called');
    await _controller?.pause();
  }

  @override
  Future<void> playOrPause() async {
    if (_controller?.value.isPlaying ?? false) {
      await pause();
    } else {
      await play();
    }
  }

  @override
  Future<void> stop() async {
    await _controller?.pause();
    await _controller?.seekTo(Duration.zero);
  }

  @override
  Future<void> seek(Duration position) async {
    if (_controller == null) return;

    print('PlayerWeb: seek called to $position');
    await _controller?.seekTo(position);
  }

  @override
  Future<void> selectAudioTrack(AudioTrack track) async {}

  @override
  Future<void> selectSubtitleTrack(SubtitleTrack track) async {}

  @override
  Future<void> addSubtitleTrack({
    required String uri,
    String? title,
    String? language,
    bool select = false,
  }) async {}

  @override
  Future<void> setVolume(double volume) async {
    print('PlayerWeb: setVolume($volume)');
    // Map 0-100 to 0.0-1.0
    await _controller?.setVolume(volume / 100.0);
    _state = _state.copyWith(volume: volume);
    _volumeController.add(volume);
  }

  @override
  Future<void> setRate(double rate) async {
    await _controller?.setPlaybackSpeed(rate);
    _state = _state.copyWith(rate: rate);
    _rateController.add(rate);
  }

  @override
  Future<void> setAudioDevice(AudioDevice device) async {}

  @override
  Future<void> setProperty(String name, String value) async {}

  @override
  Future<String?> getProperty(String name) async => null;

  @override
  Future<void> command(List<String> args) async {}

  @override
  Future<void> setAudioPassthrough(bool enabled) async {}

  @override
  Future<bool> setVisible(bool visible) async => true;

  @override
  Future<void> setControlsVisible(bool visible) async {}

  @override
  Future<void> updateFrame() async {}

  @override
  Future<void> dispose() async {
    _controller?.removeListener(_onControllerUpdate);
    await _controller?.dispose();
    _controller = null;

    await _playingController.close();
    await _completedController.close();
    await _bufferingController.close();
    await _positionController.close();
    await _durationController.close();
    await _bufferController.close();
    await _volumeController.close();
    await _rateController.close();
    await _tracksController.close();
    await _trackController.close();
    await _logController.close();
    await _errorController.close();
    await _audioDeviceController.close();
    await _audioDevicesController.close();
  }
}
