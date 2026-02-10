// Basic smoke test for the enterprise Flutter desktop app.
//
// This test verifies that the MyApp widget can be instantiated
// within a ProviderScope without errors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_app3/main.dart';
import 'package:test_app3/core/providers/app_providers.dart';

void main() {
  testWidgets('MyApp renders without errors', (WidgetTester tester) async {
    // Set up SharedPreferences mock for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app within a ProviderScope and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
        child: const MyApp(),
      ),
    );

    // Allow the router to settle
    await tester.pumpAndSettle();

    // Verify the app renders a MaterialApp (via MaterialApp.router)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
