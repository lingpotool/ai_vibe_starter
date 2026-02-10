import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app3/core/router/not_found_page.dart';

void main() {
  group('NotFoundPage', () {
    Widget buildTestApp({Brightness brightness = Brightness.light}) {
      final router = GoRouter(
        initialLocation: '/unknown',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Text('Home'),
            ),
          ),
        ],
        errorBuilder: (context, state) => const NotFoundPage(),
      );

      return MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(brightness: brightness),
      );
    }

    testWidgets('displays 404 text', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('404'), findsOneWidget);
    });

    testWidgets('displays hint text', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('页面未找到'), findsOneWidget);
    });

    testWidgets('displays return home button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('返回首页'), findsOneWidget);
    });

    testWidgets('displays explore_off icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.explore_off_rounded), findsOneWidget);
    });

    testWidgets('return home button navigates to /home', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('返回首页'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders in dark mode without errors', (tester) async {
      await tester.pumpWidget(buildTestApp(brightness: Brightness.dark));
      await tester.pumpAndSettle();

      expect(find.text('404'), findsOneWidget);
      expect(find.text('返回首页'), findsOneWidget);
    });
  });
}
