import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 排版系统 — 字体 + 字号 + 字重 统一管理
///
/// 字体策略：
///   全局基础 → Noto Sans SC（思源黑体，在 AppTheme 中设置）
///     - 中英文统一设计，字重齐全
///     - 所有正文、描述、标签默认继承此字体
///   标题/品牌 → Inter
///     - 用于页面大标题、数据数字、品牌名
///     - 几何感强，现代精致，与毛玻璃风格匹配
///   代码 → JetBrains Mono
///     - 用于版本号、代码片段等等宽场景
///
/// 字号阶梯（dp）:
///   28  — 大标题（页面顶部，每页仅一个）
///   20  — 数据数字（统计卡片中的数值）
///   16  — 卡片标题 / 设置项标题
///   14  — 正文 / 描述文本
///   13  — 辅助文本 / 次要信息
///   12  — 标签 / 徽章 / 底部导航
///   11  — 最小文本（版本号、代码片段）
class AppTypography {
  AppTypography._();

  // ── 字体族 ──
  static String get _interFamily => GoogleFonts.inter().fontFamily!;
  static String get _codeFamily => GoogleFonts.jetBrainsMono().fontFamily!;

  // ── 大标题 ── (Inter)
  static TextStyle get pageTitle => TextStyle(
    fontFamily: _interFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ── 数据数字 ── (Inter)
  static TextStyle get statValue => TextStyle(
    fontFamily: _interFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // ── 卡片标题 ── (Noto Sans SC — 继承主题)
  static const cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── 正文 ── (Noto Sans SC — 继承主题)
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── 辅助文本 ── (Noto Sans SC — 继承主题)
  static const caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ── 标签 ── (Noto Sans SC — 继承主题)
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ── 最小文本 ── (Noto Sans SC — 继承主题)
  static const micro = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── 分区头部 ── (Noto Sans SC — 继承主题)
  static const sectionHeader = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
  );

  // ── 代码文本 ── (JetBrains Mono)
  static TextStyle get code => TextStyle(
    fontFamily: _codeFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}
