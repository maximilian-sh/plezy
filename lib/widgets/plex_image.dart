import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_image.dart';

/// A wrapper around CachedNetworkImage that uses Image.network on web
/// to avoid CORS issues with external images.
class PlexImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final double? width;
  final double? height;
  final Alignment alignment;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const PlexImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      placeholder: placeholder,
      errorWidget: errorWidget,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
    );
  }
}
