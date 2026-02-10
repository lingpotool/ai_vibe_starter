import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/widgets/confirm_dialog.dart';
import 'package:test_app3/core/widgets/glass.dart';

void main() {
  group('ConfirmDialog', () {
    Widget buildTestWidget({
      Brightness brightness = Brightness.light,
    }) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: const Scaffold(body: SizedBox.shrink()),
      );
    }

    testWidgets('displays title and description', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Show the dialog
      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(
        context,
        title: 'Delete item?',
        description: 'This action cannot be undone.',
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete item?'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
    });

    testWidgets('displays title without description', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(context, title: 'Confirm action');
      await tester.pumpAndSettle();

      expect(find.text('Confirm action'), findsOneWidget);
      // Only the title text and button texts should be present in the dialog
      expect(
        find.descendant(
          of: find.byType(GlassContainer),
          matching: find.byType(Text),
        ),
        findsNWidgets(3), // title + Confirm + Cancel
      );
    });

    testWidgets('shows confirm and cancel buttons with default text',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(context, title: 'Test');
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('shows custom button text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(
        context,
        title: 'Test',
        confirmText: 'Yes',
        cancelText: 'No',
      );
      await tester.pumpAndSettle();

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('returns true when confirm is tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      final future = ConfirmDialog.show(context, title: 'Confirm?');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();

      expect(await future, isTrue);
    });

    testWidgets('returns false when cancel is tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      final future = ConfirmDialog.show(context, title: 'Confirm?');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(await future, isFalse);
    });

    testWidgets('returns false when dismissed by tapping barrier',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      final future = ConfirmDialog.show(context, title: 'Confirm?');
      await tester.pumpAndSettle();

      // Tap outside the dialog to dismiss
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(await future, isFalse);
    });

    testWidgets('uses GlassContainer for glassmorphism effect',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(context, title: 'Glass test');
      await tester.pumpAndSettle();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders in dark theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(brightness: Brightness.dark));

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(
        context,
        title: 'Dark dialog',
        description: 'Dark description',
      );
      await tester.pumpAndSettle();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Dark dialog'), findsOneWidget);
      expect(find.text('Dark description'), findsOneWidget);
    });

    testWidgets('renders in light theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(brightness: Brightness.light));

      final context = tester.element(find.byType(Scaffold));
      ConfirmDialog.show(
        context,
        title: 'Light dialog',
        description: 'Light description',
      );
      await tester.pumpAndSettle();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Light dialog'), findsOneWidget);
      expect(find.text('Light description'), findsOneWidget);
    });
  });
}
