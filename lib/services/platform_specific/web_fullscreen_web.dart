import 'dart:html' as html;

void toggleWebFullscreen() {
  if (html.document.fullscreenElement != null) {
    html.document.exitFullscreen();
  } else {
    html.document.documentElement?.requestFullscreen();
  }
}
