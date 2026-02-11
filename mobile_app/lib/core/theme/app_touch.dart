/// 触控区域规范
///
/// Android Material 推荐最小触控目标 48dp
/// iOS HIG 推荐最小触控目标 44pt
/// 本应用统一使用 48dp 作为最小触控区域。
///
/// 用法：
///   SizedBox(width: AppTouch.minTarget, height: AppTouch.minTarget, child: ...)
///   ConstrainedBox(constraints: AppTouch.minConstraints, child: ...)
library;

import 'package:flutter/material.dart';

class AppTouch {
  AppTouch._();

  /// 最小触控目标尺寸（dp）
  static const double minTarget = 48;

  /// 底部导航栏高度
  static const double bottomNavHeight = 56;

  /// 底部导航单项宽度
  static const double bottomNavItemWidth = 72;

  /// 设置项最小高度
  static const double settingsTileMinHeight = 56;

  /// 图标按钮尺寸（含 padding 的触控区域）
  static const double iconButtonSize = 44;

  /// 最小触控约束
  static const minConstraints = BoxConstraints(
    minWidth: minTarget,
    minHeight: minTarget,
  );
}
