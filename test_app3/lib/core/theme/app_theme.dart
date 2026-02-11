import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 主题系统
///
/// 字体策略：
///   全局基础字体 → Noto Sans SC（思源黑体）
///   - 中英文设计统一，字重齐全（100-900）
///   - 确保中文渲染质量，不依赖系统 fallback
///   标题字体 → Inter（通过 AppTypography 单独指定）
///   - 用于品牌英文，更精致
class AppTheme {
  AppTheme._();

  /// 构建 Noto Sans SC 文本主题
  static TextTheme _buildTextTheme(TextTheme base, Color bodyColor) {
    return GoogleFonts.notoSansScTextTheme(base).apply(
      bodyColor: bodyColor,
      displayColor: bodyColor,
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        surface: AppColors.lightBackground,
        onSurface: AppColors.lightForeground,
        surfaceContainerHighest: AppColors.lightCard,
        outline: AppColors.lightBorder,
        error: Color(0xFFDC2626),
      ),
      textTheme: _buildTextTheme(base.textTheme, AppColors.lightForeground),
      dividerColor: AppColors.lightBorder,
      splashFactory: InkSparkle.splashFactory,
      scrollbarTheme: _scrollbarTheme,
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkPrimaryForeground,
        surface: AppColors.darkBackground,
        onSurface: AppColors.darkForeground,
        surfaceContainerHighest: AppColors.darkCard,
        outline: AppColors.darkBorder,
        error: Color(0xFFEF4444),
      ),
      textTheme: _buildTextTheme(base.textTheme, AppColors.darkForeground),
      dividerColor: AppColors.darkBorder,
      splashFactory: InkSparkle.splashFactory,
      scrollbarTheme: _scrollbarTheme,
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xFF2C2C2E).withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static final _scrollbarTheme = ScrollbarThemeData(
    thickness: WidgetStateProperty.all(6),
    radius: const Radius.circular(3),
    thumbVisibility: WidgetStateProperty.all(false),
  );
}
