
class OsMediaControls {
  static Stream<dynamic> get controlEvents => const Stream.empty();
  static Future<void> setMetadata(MediaMetadata metadata) async {}
  static Future<void> setPlaybackState(MediaPlaybackState state) async {}
  static Future<void> enableControls(List<MediaControl> controls) async {}
  static Future<void> disableControls(List<MediaControl> controls) async {}
  static Future<void> clear() async {}
}

class MediaMetadata {
  final String? title;
  final String? artist;
  final String? artworkUrl;
  final Duration? duration;

  MediaMetadata({this.title, this.artist, this.artworkUrl, this.duration});
}

class MediaPlaybackState {
  final PlaybackState state;
  final Duration position;
  final double speed;

  MediaPlaybackState({required this.state, required this.position, required this.speed});
}

enum PlaybackState { playing, paused }
enum MediaControl { previous, next }
