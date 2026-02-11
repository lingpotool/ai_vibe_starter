import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/core/providers/app_providers.dart';

void main() {
  testWidgets('App smoke test — renders without errors', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          platformProvider.overrideWithValue('android'),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // App renders — find the MaterialApp.router
    expect(find.byType(MyApp), findsOneWidget);
  });
}
