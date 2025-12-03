class WindowManager {
  Future<void> ensureInitialized() async {}
  Future<void> addListener(WindowListener listener) async {}
  Future<void> removeListener(WindowListener listener) async {}
  Future<bool> isFullScreen() async => false;
  Future<void> setFullScreen(bool isFullScreen) async {}
}

final windowManager = WindowManager();

mixin WindowListener {
  void onWindowEnterFullScreen() {}
  void onWindowLeaveFullScreen() {}
  void onWindowMaximize() {}
  void onWindowUnmaximize() {}
  void onWindowResize() {}
}
