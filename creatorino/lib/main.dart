import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:creatorino/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/errors/error_handler.dart';
import 'core/logger/logger.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge: 状态栏透明，内容延伸到系统栏后面
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  ErrorHandler.init();

  final prefs = await SharedPreferences.getInstance();

  final storageService = StorageService();
  await storageService.init();

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MyApp(),
        ),
      );
    },
    (Object error, StackTrace stack) {
      AppLogger.error('zone', 'Uncaught async error: ${error.runtimeType} - $error', error, stack);
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConfig.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConfig.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
