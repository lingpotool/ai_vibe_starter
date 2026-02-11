import 'dart:ui';

/// oklch 风格的色彩系统 — 与桌面端保持一致的设计语言
class AppColors {
  AppColors._();

  // ===== Light =====
  static const lightBackground = Color(0xFFF5F5F7);
  static const lightForeground = Color(0xFF1D1B20);
  static const lightCard = Color(0xB8FFFFFF); // 72% white
  static const lightCardForeground = Color(0xFF1D1B20);
  static const lightPrimary = Color(0xFF3B5EF6);
  static const lightPrimaryForeground = Color(0xFFFAFAFA);
  static const lightMuted = Color(0x99F0F0F2); // 60%
  static const lightMutedForeground = Color(0xFF8B8B8E);
  static const lightBorder = Color(0x14000000); // 8%
  static const lightSidebar = Color(0xA6F8F8FA); // 65%
  static const lightSidebarBorder = Color(0x0F000000); // 6%
  static const lightSidebarAccent = Color(0x0D000000); // 5%

  // ===== Dark =====
  static const darkBackground = Color(0xFF1C1C1E);
  static const darkForeground = Color(0xFFFAFAFA);
  static const darkCard = Color(0x0FFFFFFF); // 6% white
  static const darkCardForeground = Color(0xFFFAFAFA);
  static const darkPrimary = Color(0xFF6B8AFF);
  static const darkPrimaryForeground = Color(0xFFFAFAFA);
  static const darkMuted = Color(0x0FFFFFFF); // 6%
  static const darkMutedForeground = Color(0xFFB0B0B3);
  static const darkBorder = Color(0x14FFFFFF); // 8%
  static const darkSidebar = Color(0x99282828); // 60%
  static const darkSidebarBorder = Color(0x0FFFFFFF); // 6%
  static const darkSidebarAccent = Color(0x14FFFFFF); // 8%
}
