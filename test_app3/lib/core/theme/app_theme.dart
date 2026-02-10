import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

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
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.lightForeground,
        displayColor: AppColors.lightForeground,
      ),
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
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.darkForeground,
        displayColor: AppColors.darkForeground,
      ),
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
