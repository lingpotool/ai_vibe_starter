import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 实例
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main()');
});

/// 暗色模式
final isDarkProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getBool('isDark') ?? false;
  }

  void toggle() {
    state = !state;
    ref.read(sharedPrefsProvider).setBool('isDark', state);
  }

  void set(bool dark) {
    state = dark;
    ref.read(sharedPrefsProvider).setBool('isDark', state);
  }
}

/// 语言
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return Locale(prefs.getString('locale') ?? 'zh');
  }

  void set(Locale locale) {
    state = locale;
    ref.read(sharedPrefsProvider).setString('locale', locale.languageCode);
  }
}

/// 平台检测
final platformProvider = Provider<String>((ref) {
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  return 'unknown';
});

/// ThemeMode 派生
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(isDarkProvider) ? ThemeMode.dark : ThemeMode.light;
});
