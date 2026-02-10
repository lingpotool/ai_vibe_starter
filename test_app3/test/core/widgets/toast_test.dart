import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/widgets/toast.dart';
import 'package:test_app3/core/widgets/glass.dart';

void main() {
  group('ToastService', () {
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

    testWidgets('shows toast message with correct text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Hello Toast');
      await tester.pump();

      expect(find.text('Hello Toast'), findsOneWidget);

      // Dismiss to cancel pending timer before test ends
      ToastService.dismiss();
    });

    testWidgets('shows success toast with check icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Success!', type: ToastType.success);
      await tester.pump();

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('shows error toast with error icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Error!', type: ToastType.error);
      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error!'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('shows info toast with info icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Info!', type: ToastType.info);
      await tester.pump();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text('Info!'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('uses GlassContainer for glassmorphism effect',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Glass toast');
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('auto-dismisses after specified duration', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(
        context,
        message: 'Auto dismiss',
        duration: const Duration(seconds: 2),
      );
      await tester.pump();

      expect(find.text('Auto dismiss'), findsOneWidget);

      // Advance time past the duration
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Auto dismiss'), findsNothing);
    });

    testWidgets('dismiss removes toast immediately', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Dismiss me');
      await tester.pump();

      expect(find.text('Dismiss me'), findsOneWidget);

      ToastService.dismiss();
      await tester.pump();

      expect(find.text('Dismiss me'), findsNothing);
    });

    testWidgets('close button dismisses toast', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Close me');
      await tester.pump();

      expect(find.text('Close me'), findsOneWidget);

      // Tap the close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.text('Close me'), findsNothing);
    });

    testWidgets('showing new toast replaces previous one', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'First toast');
      await tester.pump();

      expect(find.text('First toast'), findsOneWidget);

      ToastService.show(context, message: 'Second toast');
      await tester.pump();

      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('renders in dark theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(brightness: Brightness.dark));

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Dark toast');
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Dark toast'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('renders in light theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(brightness: Brightness.light));

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Light toast');
      await tester.pump();

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Light toast'), findsOneWidget);

      ToastService.dismiss();
    });

    testWidgets('success icon has green color', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Green', type: ToastType.success);
      await tester.pump();

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.check_circle_outline),
      );
      expect(icon.color, const Color(0xFF4CAF50));

      ToastService.dismiss();
    });

    testWidgets('error icon has red color', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Red', type: ToastType.error);
      await tester.pump();

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.error_outline),
      );
      expect(icon.color, const Color(0xFFEF5350));

      ToastService.dismiss();
    });

    testWidgets('info icon has blue color', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final context = tester.element(find.byType(Scaffold));
      ToastService.show(context, message: 'Blue', type: ToastType.info);
      await tester.pump();

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.info_outline),
      );
      expect(icon.color, const Color(0xFF42A5F5));

      ToastService.dismiss();
    });
  });
}
