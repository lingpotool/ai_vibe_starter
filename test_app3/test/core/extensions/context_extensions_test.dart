import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/extensions/context_extensions.dart';

void main() {
  group('BuildContextExtensions', () {
    Widget buildTestWidget({
      required Brightness brightness,
      required void Function(BuildContext context) onBuild,
    }) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: Builder(
          builder: (context) {
            onBuild(context);
            return const SizedBox.shrink();
          },
        ),
      );
    }

    testWidgets('theme returns current ThemeData', (tester) async {
      late ThemeData capturedTheme;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedTheme = context.theme;
        },
      ));

      expect(capturedTheme, isA<ThemeData>());
      expect(capturedTheme.brightness, Brightness.light);
    });

    testWidgets('colorScheme returns current ColorScheme', (tester) async {
      late ColorScheme capturedColorScheme;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        onBuild: (context) {
          capturedColorScheme = context.colorScheme;
        },
      ));

      expect(capturedColorScheme, isA<ColorScheme>());
      expect(capturedColorScheme.brightness, Brightness.dark);
    });

    testWidgets('textTheme returns current TextTheme', (tester) async {
      late TextTheme capturedTextTheme;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedTextTheme = context.textTheme;
        },
      ));

      expect(capturedTextTheme, isA<TextTheme>());
      expect(capturedTextTheme.bodyLarge, isNotNull);
    });

    testWidgets('isDark returns true for dark theme', (tester) async {
      late bool capturedIsDark;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        onBuild: (context) {
          capturedIsDark = context.isDark;
        },
      ));

      expect(capturedIsDark, isTrue);
    });

    testWidgets('isDark returns false for light theme', (tester) async {
      late bool capturedIsDark;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedIsDark = context.isDark;
        },
      ));

      expect(capturedIsDark, isFalse);
    });

    testWidgets('isLight returns true for light theme', (tester) async {
      late bool capturedIsLight;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedIsLight = context.isLight;
        },
      ));

      expect(capturedIsLight, isTrue);
    });

    testWidgets('isLight returns false for dark theme', (tester) async {
      late bool capturedIsLight;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        onBuild: (context) {
          capturedIsLight = context.isLight;
        },
      ));

      expect(capturedIsLight, isFalse);
    });

    testWidgets('mediaQuery returns MediaQueryData', (tester) async {
      late MediaQueryData capturedMediaQuery;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedMediaQuery = context.mediaQuery;
        },
      ));

      expect(capturedMediaQuery, isA<MediaQueryData>());
    });

    testWidgets('screenSize returns a valid Size', (tester) async {
      late Size capturedSize;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        onBuild: (context) {
          capturedSize = context.screenSize;
        },
      ));

      expect(capturedSize, isA<Size>());
      expect(capturedSize.width, greaterThan(0));
      expect(capturedSize.height, greaterThan(0));
    });

    testWidgets('isDark and isLight are mutually exclusive', (tester) async {
      late bool capturedIsDark;
      late bool capturedIsLight;

      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        onBuild: (context) {
          capturedIsDark = context.isDark;
          capturedIsLight = context.isLight;
        },
      ));

      expect(capturedIsDark, isNot(equals(capturedIsLight)));
    });
  });
}
