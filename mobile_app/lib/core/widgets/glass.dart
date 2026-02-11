import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_radius.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_elevation.dart';

/// 毛玻璃容器 — 核心视觉组件
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 24,
    this.opacity,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
  });

  final Widget child;
  final double blur;
  final double? opacity;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveOpacity = opacity ?? (isDark ? 0.06 : 0.72);
    final effectiveBorderRadius = borderRadius ?? AppRadius.borderLg;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: effectiveOpacity),
              borderRadius: effectiveBorderRadius,
              border: border ??
                  Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04),
                  ),
              boxShadow: AppElevation.low(isDark),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding = AppSpacing.cardPadding, this.margin});
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(padding: padding, margin: margin, borderRadius: AppRadius.borderMd, child: child);
  }
}
