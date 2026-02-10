import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/widgets/page_header.dart';
import 'package:test_app3/core/widgets/glass.dart';

void main() {
  group('PageHeader', () {
    Widget buildTestWidget({
      String title = 'Test Title',
      String? subtitle,
      List<Widget>? actions,
      Brightness brightness = Brightness.light,
    }) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          body: PageHeader(
            title: title,
            subtitle: subtitle,
            actions: actions,
          ),
        ),
      );
    }

    testWidgets('displays title only', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Dashboard'));

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Settings',
        subtitle: 'Manage your preferences',
      ));

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Manage your preferences'), findsOneWidget);
    });

    testWidgets('hides subtitle when null', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Home'));

      // Only the title text should be inside the GlassContainer
      expect(
        find.descendant(
          of: find.byType(GlassContainer),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Users',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ));

      expect(find.text('Users'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('displays title, subtitle, and actions together',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Reports',
        subtitle: 'View analytics data',
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Export'),
          ),
        ],
      ));

      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('View analytics data'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
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
        title: 'Dark Page',
        subtitle: 'Dark subtitle',
      ));

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Dark Page'), findsOneWidget);
      expect(find.text('Dark subtitle'), findsOneWidget);
    });

    testWidgets('renders in light theme without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        brightness: Brightness.light,
        title: 'Light Page',
        subtitle: 'Light subtitle',
      ));

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Light Page'), findsOneWidget);
      expect(find.text('Light subtitle'), findsOneWidget);
    });

    testWidgets('handles empty actions list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'No Actions',
        actions: [],
      ));

      expect(find.text('No Actions'), findsOneWidget);
      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('uses Row layout with title on left and actions on right',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Layout Test',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ));

      // The top-level child of GlassContainer should be a Row
      final glassContainer =
          tester.widget<GlassContainer>(find.byType(GlassContainer));
      expect(glassContainer.child, isA<Row>());
    });
  });
}
