import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/widgets/empty_state.dart';
import 'package:test_app3/core/widgets/glass.dart';

void main() {
  group('EmptyState', () {
    Widget buildTestWidget({
      IconData icon = Icons.inbox_outlined,
      String title = 'No data',
      String? description,
      Brightness brightness = Brightness.light,
    }) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          body: EmptyState(
            icon: icon,
            title: title,
            description: description,
          ),
        ),
      );
    }

    testWidgets('displays icon, title, and description', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.inbox_outlined,
        title: 'No items',
        description: 'Add some items to get started',
      ));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Add some items to get started'), findsOneWidget);
    });

    testWidgets('displays icon and title without description', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Empty',
      ));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);
      // No description text inside GlassContainer
      expect(
        find.descendant(
          of: find.byType(GlassContainer),
          matching: find.byType(Text),
        ),
        findsOneWidget, // only the title
      );
    });

    testWidgets('uses GlassContainer for glassmorphism effect',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders in dark theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.dark,
        title: 'Dark empty',
        description: 'Dark description',
      ));

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Dark empty'), findsOneWidget);
      expect(find.text('Dark description'), findsOneWidget);
    });

    testWidgets('renders in light theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        title: 'Light empty',
        description: 'Light description',
      ));

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Light empty'), findsOneWidget);
      expect(find.text('Light description'), findsOneWidget);
    });

    testWidgets('renders with different icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.search_off,
        title: 'No results',
      ));

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('No results'), findsOneWidget);
    });

    testWidgets('is centered on screen', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Center), findsWidgets);
    });
  });
}
