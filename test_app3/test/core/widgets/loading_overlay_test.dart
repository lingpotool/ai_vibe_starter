import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/widgets/loading_overlay.dart';
import 'package:test_app3/core/widgets/glass.dart';

void main() {
  group('LoadingOverlay', () {
    Widget buildTestWidget({
      bool isLoading = true,
      String? message,
      Widget? child,
      Brightness brightness = Brightness.light,
    }) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          body: LoadingOverlay(
            isLoading: isLoading,
            message: message,
            child: child,
          ),
        ),
      );
    }

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('hides overlay when isLoading is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: false));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GlassContainer), findsNothing);
    });

    testWidgets('displays message text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Loading data...'));

      expect(find.text('Loading data...'), findsOneWidget);
    });

    testWidgets('does not display message text when not provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Only the CircularProgressIndicator should be present, no Text widget
      // inside the GlassContainer
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // No text widget as a descendant of GlassContainer
      expect(
        find.descendant(
          of: find.byType(GlassContainer),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });

    testWidgets('renders child widget underneath overlay', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        child: const Text('Content below'),
      ));

      expect(find.text('Content below'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in dark theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        message: 'Dark loading...',
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Dark loading...'), findsOneWidget);
    });

    testWidgets('renders in light theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        message: 'Light loading...',
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Light loading...'), findsOneWidget);
    });

    testWidgets('uses GlassContainer for glassmorphism effect',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify GlassContainer is used (which provides BackdropFilter)
      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
