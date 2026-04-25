import 'package:flutter/material.dart';

/// 统一图片加载组件，自动判断使用 AssetImage 还是 NetworkImage
class AppImage extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  const AppImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) {
      return _buildError(context, null, null);
    }

    // 根据路径前缀判断是本地资源还是网络图片
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      );
    }

    return Image.network(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      loadingBuilder: loadingBuilder,
    );
  }

  Widget _buildError(BuildContext context, Object? error, StackTrace? stackTrace) {
    if (errorBuilder != null) {
      return errorBuilder!(context, error ?? Exception('图片路径为空'), stackTrace);
    }
    return _defaultErrorBuilder(context, error ?? Exception('图片路径为空'), stackTrace);
  }

  static Widget _defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return const Icon(
      Icons.person,
      color: Colors.white,
    );
  }
}
