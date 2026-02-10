// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'My App';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome to';

  @override
  String get appDescription =>
      'A refined desktop app template built with Flutter.';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get step1 => 'Create new feature modules in lib/features/';

  @override
  String get step2 => 'Add route config in router.dart';

  @override
  String get step3 => 'Sidebar menu auto-generates from routes';

  @override
  String get step4 => 'Manage state with Riverpod';

  @override
  String get activeToday => 'Active Today';

  @override
  String get totalTasks => 'Total Tasks';

  @override
  String get completion => 'Completion';

  @override
  String get pending => 'Pending';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDesc => 'Toggle light/dark theme';

  @override
  String get language => 'Language';

  @override
  String get languageDesc => 'Switch display language';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get currentPlatform => 'Current Platform';

  @override
  String get appearance => 'Appearance';
}
