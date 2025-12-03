import 'dart:io';
import 'player.dart';
import 'player_native.dart';
import 'platform/player_windows.dart';
import 'platform/player_linux.dart';

Player createPlayer() {
  if (Platform.isMacOS || Platform.isIOS || Platform.isAndroid) {
    return PlayerNative();
  }
  if (Platform.isWindows) {
    return PlayerWindows();
  }
  if (Platform.isLinux) {
    return PlayerLinux();
  }
  throw UnsupportedError('Player is not supported on this platform');
}
