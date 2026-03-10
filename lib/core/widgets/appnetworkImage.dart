import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Optional blurhash:
// import 'package:flutter_blurhash/flutter_blurhash.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;

  /// Sizing
  final double? width;
  final double? height;

  /// Shape
  final bool isCircle;
  final double borderRadius; // used when !isCircle
  final BoxFit fit;

  /// Placeholder / fallback
  final String? placeholderAsset; // e.g. AppImages.profileImage
  final IconData fallbackIcon;

  /// Border (optional)
  final double borderWidth;
  final Color borderColor;

  /// Error UI
  final bool showRetryOnError;

  /// Cache behavior
  final int? memCacheWidth;
  final int? memCacheHeight;

  /// Optional blurhash string
  final String? blurHash;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.isCircle = false,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
    this.placeholderAsset,
    this.fallbackIcon = Icons.person,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.showRetryOnError = true,
    this.memCacheWidth,
    this.memCacheHeight,
    this.blurHash,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? (isCircle ? (height ?? 80) : double.infinity);
    final h = height ?? (isCircle ? (width ?? 80) : 160);

    // Empty URL fallback
    if (url == null || url!.trim().isEmpty) {
      return _wrapShape(
        child: _assetOrIconPlaceholder(w: w, h: h),
        w: w,
        h: h,
      );
    }

    return _wrapShape(
      w: w,
      h: h,
      child: CachedNetworkImage(
        imageUrl: url!.trim(),
        width: w,
        height: h,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 180),
        fadeOutDuration: const Duration(milliseconds: 120),

        // Loading
        placeholder: (context, _) {
          // If you want blurhash as placeholder uncomment below:
          // if (blurHash != null && blurHash!.trim().isNotEmpty) {
          //   return BlurHash(hash: blurHash!, imageFit: fit);
          // }

          return _shimmer(w: w, h: h);
        },

        // Error
        errorWidget: (context, _, __) {
          return _errorBox(
            context: context,
            w: w,
            h: h,
            onRetry: () {
              // CachedNetworkImage will retry on rebuild;
              // easiest: trigger rebuild by using GetX/State set,
              // but for generic widget we just call imageCache clear for that URL:
              CachedNetworkImage.evictFromCache(url!.trim());
              (context as Element).markNeedsBuild();
            },
          );
        },
      ),
    );
  }

  Widget _wrapShape({required Widget child, required double w, required double h}) {
    final decorated = Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (isCircle) return decorated;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: decorated,
    );
  }

  Widget _shimmer({required double w, required double h}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: w,
        height: h,
        color: Colors.white,
      ),
    );
  }

  Widget _assetOrIconPlaceholder({required double w, required double h}) {
    if (placeholderAsset != null && placeholderAsset!.trim().isNotEmpty) {
      return Image.asset(
        placeholderAsset!,
        width: w,
        height: h,
        fit: fit,
      );
    }

    return Container(
      width: w,
      height: h,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(fallbackIcon, color: Colors.grey.shade600, size: isCircle ? (w * 0.45) : 28),
    );
  }

  Widget _errorBox({
    required BuildContext context,
    required double w,
    required double h,
    required VoidCallback onRetry,
  }) {
    return Container(
      width: w,
      height: h,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey.shade700),
          const SizedBox(height: 6),
          Text(
            "Image load failed",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
          if (showRetryOnError) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
            ),
          ]
        ],
      ),
    );
  }
}