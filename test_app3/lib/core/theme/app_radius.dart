import 'package:flutter/material.dart';

/// 圆角系统 — 4 级层级
///
/// 所有 borderRadius 必须使用此处定义的值。
///
///   4   — xs   代码片段、小标签、徽章
///   8   — sm   按钮、输入框、图标容器
///   12  — md   卡片、GlassContainer
///   16  — lg   大卡片、弹窗、模态框
///   24  — xl   圆形按钮、头像
///   full — 圆形（用于 toggle switch 等）
class AppRadius {
  AppRadius._();

  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 999;

  // ── 常用 BorderRadius ──
  static final borderXs   = BorderRadius.circular(xs);
  static final borderSm   = BorderRadius.circular(sm);
  static final borderMd   = BorderRadius.circular(md);
  static final borderLg   = BorderRadius.circular(lg);
  static final borderXl   = BorderRadius.circular(xl);
  static final borderFull  = BorderRadius.circular(full);
}
