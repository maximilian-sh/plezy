import 'package:flutter/material.dart';

class WindowManipulator {
  static Future<void> initialize({bool enableWindowDelegate = false}) async {}
  static Future<void> addNSWindowDelegate(dynamic delegate) async {}
  static Future<void> makeTitlebarTransparent() async {}
  static Future<void> hideTitle() async {}
  static Future<void> enableFullSizeContentView() async {}
  static Future<void> addToolbar() async {}
  static Future<void> removeToolbar() async {}
  static Future<void> showTitle() async {}
  static Future<void> makeTitlebarOpaque() async {}
  static Future<void> overrideStandardWindowButtonPosition({required dynamic buttonType, Offset? offset}) async {}
  static Future<void> showCloseButton() async {}
  static Future<void> showMiniaturizeButton() async {}
  static Future<void> showZoomButton() async {}
  static Future<void> hideCloseButton() async {}
  static Future<void> hideMiniaturizeButton() async {}
  static Future<void> hideZoomButton() async {}
  static Future<void> enterFullscreen() async {}
  static Future<void> exitFullscreen() async {}
}

class NSAppPresentationOptions {
  static NSAppPresentationOptions from(Set<dynamic> options) => NSAppPresentationOptions();
  void applyAsFullScreenPresentationOptions() {}
}

class NSAppPresentationOption {
  static const fullScreen = 0;
  static const autoHideToolbar = 1;
  static const autoHideMenuBar = 2;
  static const autoHideDock = 3;
}
