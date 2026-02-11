import 'package:flutter/material.dart';
import 'glass.dart';

/// 确认对话框 — 毛玻璃风格
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title, this.description, this.confirmText = 'Confirm', this.cancelText = 'Cancel'});
  final String title;
  final String? description;
  final String confirmText;
  final String cancelText;

  static Future<bool> show(BuildContext context, {required String title, String? description, String confirmText = 'Confirm', String cancelText = 'Cancel'}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => ConfirmDialog(title: title, description: description, confirmText: confirmText, cancelText: cancelText),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
              if (description != null) ...[const SizedBox(height: 8), Text(description!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)))],
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelText)),
                const SizedBox(width: 8),
                FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(confirmText)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
