import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';
import '../logger/logger.dart';

/// Platform utility service for mobile.
class SystemService {
  SystemService._();
  static const String _module = 'system';

  static Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri)) throw Exception('Could not launch $url');
      AppLogger.info(_module, 'Opened URL: $url');
    } catch (e, stack) {
      AppLogger.error(_module, 'Failed to open URL: $url', e, stack);
      rethrow;
    }
  }

  static Future<String> readClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? '';
  }

  static Future<void> writeClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static String getAppVersion() => AppConfig.version;

  static String getPlatform() => Platform.operatingSystem;
}
