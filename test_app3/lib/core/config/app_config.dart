import 'dart:ui';

/// Centralized, immutable application configuration.
///
/// All fields are compile-time constants so they can be referenced
/// throughout the app without risk of accidental mutation.
class AppConfig {
  // Private constructor prevents instantiation.
  AppConfig._();

  /// Human-readable application name.
  static const String name = 'My App';

  /// Short application description.
  static const String description = 'A beautiful desktop application';

  /// Semantic version string.
  static const String version = '0.1.0';

  /// BCP-47 language tag used as the default locale.
  static const String defaultLocale = 'zh';

  /// All locales the application supports.
  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('en'),
  ];
}
