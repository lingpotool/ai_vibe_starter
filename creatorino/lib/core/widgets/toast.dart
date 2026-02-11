import 'dart:async';
import 'package:flutter/material.dart';
import 'glass.dart';

enum ToastType { success, error, info }

class ToastService {
  ToastService._();
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    dismiss();
    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(message: message, type: type, onDismiss: dismiss),
    );
    overlay.insert(_currentEntry!);
    _dismissTimer = Timer(duration, dismiss);
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastOverlay extends StatelessWidget {
  const _ToastOverlay({required this.message, required this.type, required this.onDismiss});
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GlassContainer(
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            border: Border.all(color: _accentColor(type).withValues(alpha: 0.3)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon(type), size: 20, color: _accentColor(type)),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(Icons.close, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData _icon(ToastType type) => switch (type) {
    ToastType.success => Icons.check_circle_outline,
    ToastType.error => Icons.error_outline,
    ToastType.info => Icons.info_outline,
  };

  static Color _accentColor(ToastType type) => switch (type) {
    ToastType.success => const Color(0xFF4CAF50),
    ToastType.error => const Color(0xFFEF5350),
    ToastType.info => const Color(0xFF42A5F5),
  };
}
