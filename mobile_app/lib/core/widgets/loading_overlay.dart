import 'package:flutter/material.dart';
import 'glass.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.isLoading = true, this.message, this.child});
  final bool isLoading;
  final String? message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(children: [
      ?child,
      if (isLoading) Positioned.fill(
        child: ColoredBox(
          color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.3),
          child: Center(
            child: GlassContainer(
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3, color: colorScheme.primary)),
                if (message != null) ...[const SizedBox(height: 16), Text(message!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)), textAlign: TextAlign.center)],
              ]),
            ),
          ),
        ),
      ),
    ]);
  }
}
