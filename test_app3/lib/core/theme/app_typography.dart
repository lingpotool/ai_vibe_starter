import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 排版系统 — 桌面端字体 + 字号 + 字重 统一管理
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
/// 桌面端字号阶梯（dp）— 比移动端略小，信息密度更高：
///   22  — 大标题（页面顶部，每页仅一个）
///   18  — 数据数字（统计卡片中的数值）
///   14  — 卡片标题 / 设置项标题
///   13  — 正文 / 描述文本
///   12  — 辅助文本 / 次要信息
///   11  — 标签 / 徽章 / 侧边栏导航
///   10  — 最小文本（版本号、代码片段）
class AppTypography {
  AppTypography._();

  // ── 字体族 ──
  static String get _interFamily => GoogleFonts.inter().fontFamily!;
  static String get _codeFamily => GoogleFonts.jetBrainsMono().fontFamily!;

  // ── 大标题 ── (Inter)
  // 用途：页面顶部标题
  static TextStyle get pageTitle => TextStyle(
    fontFamily: _interFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ── 数据数字 ── (Inter)
  // 用途：统计卡片中的大数字
  static TextStyle get statValue => TextStyle(
    fontFamily: _interFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // ── 卡片标题 ── (Noto Sans SC — 继承主题)
  // 用途：GlassContainer 内的标题行、设置项名称
  static const cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── 正文 ── (Noto Sans SC — 继承主题)
  // 用途：描述文本、设置项副标题、步骤说明
  static const body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── 辅助文本 ── (Noto Sans SC — 继承主题)
  // 用途：页面副标题、信息行标签、统计卡片标签
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ── 标签 ── (Noto Sans SC — 继承主题)
  // 用途：侧边栏 tooltip、语言切换按钮、徽章
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ── 最小文本 ── (Noto Sans SC — 继承主题)
  // 用途：步骤编号、小标签
  static const micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── 分区头部 ── (Noto Sans SC — 继承主题)
  // 用途：设置页的 "外观"、"关于" 等分区标签
  static const sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
  );

  // ── 代码文本 ── (JetBrains Mono)
  // 用途：版本号、代码片段、路径
  static TextStyle get code => TextStyle(
    fontFamily: _codeFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}
