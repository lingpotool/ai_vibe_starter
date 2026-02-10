import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../logger/logger.dart';

/// Platform utility service providing system-level operations.
///
/// All methods are static – no instantiation required.
///
/// - [openUrl]: opens a URL in the default browser via `url_launcher`.
/// - [showInFolder]: reveals a file/folder in the native file manager.
/// - [readClipboard] / [writeClipboard]: system clipboard access.
/// - [getAppVersion]: returns [AppConfig.version].
/// - [getPlatform]: returns the current OS identifier.
class SystemService {
  // Private constructor – all members are static.
  SystemService._();

  static const String _module = 'system';

  // ------------------------------------------------------------------
  // URL
  // ------------------------------------------------------------------

  /// Opens [url] in the system default browser.
  ///
  /// Logs an error and rethrows if the URL cannot be launched.
  static Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri);
      if (!launched) {
        throw Exception('Could not launch $url');
      }
      AppLogger.info(_module, 'Opened URL: $url');
    } catch (e, stack) {
      AppLogger.error(_module, 'Failed to open URL: $url', e, stack);
      rethrow;
    }
  }

  // ------------------------------------------------------------------
  // File manager
  // ------------------------------------------------------------------

  /// Reveals [path] in the native file manager.
  ///
  /// - **macOS**: `open -R <path>`
  /// - **Windows**: `explorer /select,<path>`
  /// - **Linux**: `xdg-open <parent-directory>`
  static Future<void> showInFolder(String path) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', ['-R', path]);
      } else if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', path]);
      } else if (Platform.isLinux) {
        // xdg-open opens the parent directory so the file is visible.
        final parent = File(path).parent.path;
        await Process.run('xdg-open', [parent]);
      } else {
        throw UnsupportedError(
          'showInFolder is not supported on ${Platform.operatingSystem}',
        );
      }
      AppLogger.info(_module, 'Showed in folder: $path');
    } catch (e, stack) {
      AppLogger.error(_module, 'Failed to show in folder: $path', e, stack);
      rethrow;
    }
  }

  // ------------------------------------------------------------------
  // Clipboard
  // ------------------------------------------------------------------

  /// Reads the current text content from the system clipboard.
  ///
  /// Returns an empty string if the clipboard is empty or contains
  /// non-text data.
  static Future<String> readClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? '';
  }

  /// Writes [text] to the system clipboard.
  static Future<void> writeClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  // ------------------------------------------------------------------
  // App metadata
  // ------------------------------------------------------------------

  /// Returns the application version string from [AppConfig].
  static String getAppVersion() {
    return AppConfig.version;
  }

  /// Returns the current operating system identifier.
  ///
  /// Possible values: `macos`, `windows`, `linux`.
  static String getPlatform() {
    return Platform.operatingSystem;
  }
}
