import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app3/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'core/config/app_config.dart';
import 'core/errors/error_handler.dart';
import 'core/logger/logger.dart';
import 'core/services/storage_service.dart';
import 'core/services/tray_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 全局错误处理初始化 (Req 2.1, 2.2)
  ErrorHandler.init();

  // 窗口管理初始化
  await windowManager.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // StorageService 初始化 (Req 5.1, 5.2)
  final storageService = StorageService();
  await storageService.init();

  // 系统托盘初始化 (Req 7.1)
  await TrayService.init();

  // Requirement 4.3 – 使用 AppConfig.name 替代硬编码字符串
  final windowOptions = WindowOptions(
    size: const Size(1200, 800),
    minimumSize: const Size(900, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: AppConfig.name,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Requirement 2.3 – runZonedGuarded captures async exceptions in the zone
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
      // Requirement 2.4 – log error type, message, and stack trace
      AppLogger.error(
        'zone',
        'Uncaught async error: ${error.runtimeType} - $error',
        error,
        stack,
      );
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Requirement 4.3 – 使用 AppConfig 替代硬编码字符串
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
