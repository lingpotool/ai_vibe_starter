import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app3/core/widgets/glass.dart';

/// A 404 "Not Found" page displayed when the user navigates to an undefined
/// route.
///
/// Uses the glassmorphism design style consistent with the rest of the app.
/// Provides a "返回首页" (Return to Home) button that navigates back to `/home`.
///
/// **Validates: Requirement 9.2**
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 404 icon
              Icon(
                Icons.explore_off_rounded,
                size: 72,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),

              // 404 title
              Text(
                '404',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),

              // Hint text
              Text(
                '页面未找到',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 32),

              // Return to home button
              FilledButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('返回首页'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
