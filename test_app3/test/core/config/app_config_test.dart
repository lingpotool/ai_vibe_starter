import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('name is a non-empty String', () {
      expect(AppConfig.name, isA<String>());
      expect(AppConfig.name, isNotEmpty);
      expect(AppConfig.name, 'My App');
    });

    test('description is a non-empty String', () {
      expect(AppConfig.description, isA<String>());
      expect(AppConfig.description, isNotEmpty);
      expect(AppConfig.description, 'A beautiful desktop application');
    });

    test('version follows semantic versioning format', () {
      expect(AppConfig.version, isA<String>());
      expect(AppConfig.version, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect(AppConfig.version, '0.1.0');
    });

    test('defaultLocale is a valid BCP-47 tag', () {
      expect(AppConfig.defaultLocale, isA<String>());
      expect(AppConfig.defaultLocale, isNotEmpty);
      expect(AppConfig.defaultLocale, 'zh');
    });

    test('supportedLocales contains at least the default locale', () {
      expect(AppConfig.supportedLocales, isA<List<Locale>>());
      expect(AppConfig.supportedLocales, isNotEmpty);
      expect(
        AppConfig.supportedLocales.any(
          (l) => l.languageCode == AppConfig.defaultLocale,
        ),
        isTrue,
      );
    });

    test('supportedLocales contains zh and en', () {
      final codes = AppConfig.supportedLocales.map((l) => l.languageCode).toList();
      expect(codes, contains('zh'));
      expect(codes, contains('en'));
    });

    test('class cannot be instantiated (private constructor)', () {
      // This is a compile-time guarantee — the private constructor
      // prevents `AppConfig()` from compiling outside the library.
      // We simply verify the static fields are accessible.
      expect(AppConfig.name, isNotNull);
      expect(AppConfig.description, isNotNull);
      expect(AppConfig.version, isNotNull);
      expect(AppConfig.defaultLocale, isNotNull);
      expect(AppConfig.supportedLocales, isNotNull);
    });
  });
}
