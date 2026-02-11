import 'package:flutter/material.dart';

/// 间距系统 — 基于 4dp 网格
///
/// 所有 padding / margin / gap 必须使用此处定义的值。
/// 禁止硬编码数字，确保全局节奏一致。
///
/// 4dp 网格阶梯：
///   2   — xxs  极小（分割线间距、微调）
///   4   — xs   图标与文字间距
///   8   — sm   紧凑间距（同组元素之间）
///   12  — md   标准间距（卡片内元素之间）
///   16  — lg   宽松间距（区块之间）
///   20  — xl   页面水平边距
///   24  — xxl  区块间大间距
///   32  — xxxl 页面底部留白
///   48  — huge 特殊大间距
class AppSpacing {
  AppSpacing._();

  static const double xxs  = 2;
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double xxl  = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  // ── 常用页面级 EdgeInsets ──

  /// 页面内容 padding（左右 xl，上 lg，下 xxl）
  static const pagePadding = EdgeInsets.fromLTRB(xl, lg, xl, xxl);

  /// 卡片内 padding
  static const cardPadding = EdgeInsets.all(xl);

  /// 卡片内紧凑 padding（标题行等）
  static const cardPaddingCompact = EdgeInsets.symmetric(horizontal: xl, vertical: lg);

  /// 列表项 padding
  static const tilePadding = EdgeInsets.symmetric(horizontal: xl, vertical: lg);

  /// 网格间距
  static const gridSpacing = md;
}
