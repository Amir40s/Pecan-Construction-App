import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/appnetworkImage.dart';

class GlassIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const GlassIconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withOpacity(0.7),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}


class Card extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;

  const Card({
    required this.child,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CircleIcon extends StatelessWidget {
  final Widget child;
  final Color bg;

  const CircleIcon({required this.child, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}

class Pill extends StatelessWidget {
  final Widget child;
  final Color bg;
  final Color borderColor;

  const Pill({required this.child, required this.bg, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class NameChip extends StatelessWidget {
  final String name;

  const NameChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: AppText(
          name,
          color: const Color(0xFF111827),
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AttachmentTile extends StatelessWidget {
  final String iconSvg;
  final String title;
  final String subtitle;

  final bool isImageThumb;
  final String? thumbAsset;
  final String? networkUrl;

  const AttachmentTile({
    required this.iconSvg,
    required this.title,
    required this.subtitle,
    this.isImageThumb = false,
    this.thumbAsset,
    this.networkUrl,
  });

  @override
  Widget build(BuildContext context) {
    final border = const Color(0xFFE5E7EB);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isImageThumb) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppNetworkImage(
                url: networkUrl,
                height: 36.w,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholderAsset: thumbAsset,
              ),
            ),
          ] else ...[
            Center(
              child: SvgPicture.asset(
                iconSvg,
                width: 26,
                height: 26,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2563EB),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          AppText(
            title,
            color: const Color(0xFF111827),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          AppText(
            subtitle,
            color: const Color(0xFF6B7280),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}