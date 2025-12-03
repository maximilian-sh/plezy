import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class WebImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const WebImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  @override
  State<WebImage> createState() => _WebImageState();
}

class _WebImageState extends State<WebImage> {
  late String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'web-image-${DateTime.now().microsecondsSinceEpoch}';
    // Register the view factory
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final element = web.document.createElement('img') as web.HTMLImageElement;
      element.src = widget.imageUrl;
      element.style.width = '100%';
      element.style.height = '100%';

      // Handle object-fit
      if (widget.fit != null) {
        String objectFit = 'fill';
        switch (widget.fit!) {
          case BoxFit.contain:
            objectFit = 'contain';
            break;
          case BoxFit.cover:
            objectFit = 'cover';
            break;
          case BoxFit.fill:
            objectFit = 'fill';
            break;
          case BoxFit.fitHeight:
          case BoxFit.fitWidth:
          case BoxFit.none:
          case BoxFit.scaleDown:
            objectFit = 'none'; // Approximation
            break;
        }
        element.style.objectFit = objectFit;
      }

      return element;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}
