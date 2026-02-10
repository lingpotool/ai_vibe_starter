import 'package:flutter/material.dart';

/// 多层径向渐变背景 — 给玻璃态提供可透出的色彩内容
class MeshGradientBackground extends StatelessWidget {
  const MeshGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // 底色
        Positioned.fill(
          child: ColoredBox(
            color: isDark
                ? const Color(0xFF1C1C1E)
                : const Color(0xFFF5F5F7),
          ),
        ),
        // 渐变层
        if (isDark) ...[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF3B5EF6).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, 0.8),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF9B59B6).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ] else ...[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF3B5EF6).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, 0.8),
                  radius: 1.2,
                  colors: [
                    const Color(0xFFAB47BC).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, -0.6),
                  radius: 1.0,
                  colors: [
                    const Color(0xFF26A69A).withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
        // 内容
        Positioned.fill(child: child),
      ],
    );
  }
}
