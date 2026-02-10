import 'package:flutter/material.dart';
import 'glass.dart';

/// 页面头部组件 — 标题 + 副标题 + 操作按钮区域
///
/// 显示页面标题、可选副标题和可选的操作按钮区域，
/// 使用 [GlassContainer] 风格，自动适配亮色/暗色主题。
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  /// 页面标题（必填）
  final String title;

  /// 可选的副标题
  final String? subtitle;

  /// 可选的操作按钮列表，显示在右侧
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // 左侧：标题 + 副标题
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ],
            ),
          ),
          // 右侧：操作按钮
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!
                  .expand((action) => [
                        action,
                        const SizedBox(width: 8),
                      ])
                  .toList()
                ..removeLast(), // remove trailing spacer
            ),
          ],
        ],
      ),
    );
  }
}
