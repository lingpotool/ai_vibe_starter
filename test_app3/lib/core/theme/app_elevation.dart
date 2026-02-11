import 'package:flutter/material.dart';

/// 阴影/层级系统
///
/// 定义不同层级的阴影样式，确保视觉层次一致。
/// 毛玻璃风格下阴影要克制，主要靠模糊和透明度区分层级。
///
/// 层级：
///   none   — 无阴影（平面元素）
///   low    — 卡片、列表项（微弱阴影，暗示可交互）
///   medium — 浮动元素、下拉菜单、NavRail
///   high   — 弹窗、模态框、Toast
class AppElevation {
  AppElevation._();

  static List<BoxShadow> none(bool isDark) => [];

  /// 卡片级阴影 — GlassContainer 默认
  static List<BoxShadow> low(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// 浮动元素阴影 — NavRail、悬浮按钮
  static List<BoxShadow> medium(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// 弹窗级阴影 — Dialog、Toast、Modal
  static List<BoxShadow> high(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];
}
