/// 触控/交互区域规范 — 桌面端
///
/// 桌面端使用鼠标交互，触控目标可以比移动端更小。
/// 但仍需保证足够的点击区域以避免误操作。
///
/// 用法：
///   SizedBox(width: AppTouch.minTarget, height: AppTouch.minTarget, child: ...)
///   ConstrainedBox(constraints: AppTouch.minConstraints, child: ...)
library;

import 'package:flutter/material.dart';

class AppTouch {
  AppTouch._();

  /// 最小点击目标尺寸（dp）— 桌面端 36dp 足够
  static const double minTarget = 36;

  /// NavRail 宽度
  static const double navRailWidth = 56;

  /// NavRail 按钮尺寸
  static const double navRailButtonSize = 36;

  /// 标题栏高度（macOS）
  static const double titleBarHeightMac = 38;

  /// 标题栏高度（Windows）
  static const double titleBarHeightWin = 44;

  /// 窗口控制按钮宽度
  static const double windowButtonWidth = 46;

  /// 设置项最小高度
  static const double settingsTileMinHeight = 48;

  /// 图标按钮尺寸
  static const double iconButtonSize = 36;

  /// 最小点击约束
  static const minConstraints = BoxConstraints(
    minWidth: minTarget,
    minHeight: minTarget,
  );
}
