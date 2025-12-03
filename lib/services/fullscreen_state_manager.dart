import 'platform_specific/platform_helper.dart' show Platform;
import 'package:flutter/foundation.dart';
import 'platform_specific/window_manager_helper.dart';

import 'platform_specific/web_fullscreen_helper.dart';

/// Global manager for tracking fullscreen state across the app
class FullscreenStateManager extends ChangeNotifier with WindowListener {
  static final FullscreenStateManager _instance =
      FullscreenStateManager._internal();

  factory FullscreenStateManager() => _instance;

  FullscreenStateManager._internal();

  bool _isFullscreen = false;
  bool _isListening = false;

  bool get isFullscreen => _isFullscreen;

  /// Manually set fullscreen state (called by NSWindowDelegate callbacks on macOS)
  void setFullscreen(bool value) {
    if (_isFullscreen != value) {
      _isFullscreen = value;
      notifyListeners();
    }
  }

  /// Start monitoring fullscreen state
  void startMonitoring() {
    if (!_shouldMonitor() || _isListening) return;

    // Use window_manager listener for Windows/Linux
    // macOS uses NSWindowDelegate callbacks instead (see FullscreenWindowDelegate)
    if (!Platform.isMacOS) {
      windowManager.addListener(this);
      _isListening = true;
    }
  }

  /// Stop monitoring fullscreen state
  void stopMonitoring() {
    if (_isListening) {
      windowManager.removeListener(this);
      _isListening = false;
    }
  }

  bool _shouldMonitor() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  // WindowListener callbacks for Windows/Linux
  @override
  void onWindowEnterFullScreen() {
    setFullscreen(true);
  }

  @override
  void onWindowLeaveFullScreen() {
    setFullscreen(false);
  }

  /// Toggle fullscreen mode
  Future<void> toggleFullscreen() async {
    if (kIsWeb) {
      toggleWebFullscreen();
      // Since we can't easily detect fullscreen changes on web without more complex listeners,
      // we might need to manually toggle the state here or add a listener in the helper.
      // For now, we'll assume the toggle works and flip the state.
      // In a real implementation, we should listen to 'fullscreenchange' event.
      setFullscreen(!_isFullscreen);
    } else {
      if (await windowManager.isFullScreen()) {
        await windowManager.setFullScreen(false);
      } else {
        await windowManager.setFullScreen(true);
      }
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
