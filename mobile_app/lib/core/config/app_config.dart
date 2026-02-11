import 'dart:ui';

/// Centralized, immutable application configuration.
class AppConfig {
  AppConfig._();

  static const String name = 'My App';
  static const String description = 'A beautiful mobile application';
  static const String version = '0.1.0';
  static const String defaultLocale = 'zh';

  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('en'),
  ];
}
