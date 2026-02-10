import 'dart:async';
import 'package:flutter/material.dart';
import 'glass.dart';

/// Toast 消息类型
enum ToastType { success, error, info }

/// Toast 通知服务 — 支持 success/error/info 三种类型的短暂提示消息
///
/// 使用 [OverlayEntry] 在屏幕顶部显示毛玻璃风格的 Toast 消息，
/// 自动适配亮色/暗色主题，消息在指定时间后自动消失。
///
/// **Validates: Requirements 11.4, 11.6**
class ToastService {
  ToastService._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// 显示 Toast 消息
  ///
  /// [context] — 用于获取 Overlay 的 BuildContext
  /// [message] — 提示消息文本
  /// [type] — Toast 类型（success/error/info）
  /// [duration] — 显示时长，默认 3 秒
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    dismiss();

    final overlay = Overlay.of(context);

    _currentEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: type,
        onDismiss: dismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    _dismissTimer = Timer(duration, dismiss);
  }

  /// 立即关闭当前 Toast
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

/// Toast 覆盖层 Widget — 显示在屏幕顶部
class _ToastOverlay extends StatelessWidget {
  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GlassContainer(
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            border: Border.all(
              color: _borderColor(type),
              width: 1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon(type),
                  size: 20,
                  color: _accentColor(type),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 根据类型返回对应图标
  static IconData _icon(ToastType type) {
    return switch (type) {
      ToastType.success => Icons.check_circle_outline,
      ToastType.error => Icons.error_outline,
      ToastType.info => Icons.info_outline,
    };
  }

  /// 根据类型返回强调色
  static Color _accentColor(ToastType type) {
    return switch (type) {
      ToastType.success => const Color(0xFF4CAF50),
      ToastType.error => const Color(0xFFEF5350),
      ToastType.info => const Color(0xFF42A5F5),
    };
  }

  /// 根据类型返回边框色（半透明强调色）
  static Color _borderColor(ToastType type) {
    return _accentColor(type).withValues(alpha: 0.3);
  }
}
