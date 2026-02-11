import 'dart:ui';

/// Centralized, immutable application configuration.
class AppConfig {
  AppConfig._();

  static const String name = 'Creatorino';
  static const String description = '创作者 — 释放你的创造力';
  static const String version = '0.1.0';
  static const String defaultLocale = 'zh';

  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('en'),
  ];
}
