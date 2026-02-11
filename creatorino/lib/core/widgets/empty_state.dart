import 'package:flutter/material.dart';
import 'glass.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.description});
  final IconData icon;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: GlassContainer(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8), fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          if (description != null) ...[const SizedBox(height: 8), Text(description!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)), textAlign: TextAlign.center)],
        ]),
      ),
    );
  }
}
