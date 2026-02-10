import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Structured logging service for the application.
///
/// Provides [info], [warn], and [error] methods that format log messages
/// with ISO 8601 timestamps, log level, and module tags.
///
/// - **Debug mode** (`kDebugMode`): outputs via `dart:developer` `log()`.
/// - **Release mode**: appends to a date-named file under the app logs directory.
class AppLogger {
  // Private constructor – all members are static.
  AppLogger._();

  // ------------------------------------------------------------------
  // Public API
  // ------------------------------------------------------------------

  /// Log an informational message.
  static void info(String module, String message) {
    _log('INFO', module, message);
  }

  /// Log a warning message.
  static void warn(String module, String message) {
    _log('WARN', module, message);
  }

  /// Log an error message, optionally including an [error] object and
  /// [stackTrace].
  static void error(
    String module,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log('ERROR', module, message, error, stackTrace);
  }

  // ------------------------------------------------------------------
  // Formatting (public for testability – Property 1)
  // ------------------------------------------------------------------

  /// Formats a log line according to the canonical format:
  ///
  /// ```
  /// [2025-01-15 10:30:00] [INFO] [storage] message content
  /// ```
  ///
  /// When [error] is provided the exception's string representation is
  /// appended. When [stackTrace] is also provided it is appended on a
  /// new line.
  static String formatMessage(
    String level,
    String module,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final timestamp = _formatTimestamp(DateTime.now());
    return _formatMessageWithTimestamp(
      timestamp,
      level,
      module,
      message,
      error,
      stackTrace,
    );
  }

  /// Same as [formatMessage] but accepts an explicit [timestamp] so that
  /// tests can supply a deterministic value.
  @visibleForTesting
  static String formatMessageWithTimestamp(
    DateTime timestamp,
    String level,
    String module,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    return _formatMessageWithTimestamp(
      _formatTimestamp(timestamp),
      level,
      module,
      message,
      error,
      stackTrace,
    );
  }

  // ------------------------------------------------------------------
  // Internal helpers
  // ------------------------------------------------------------------

  static String _formatMessageWithTimestamp(
    String timestamp,
    String level,
    String module,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final buffer = StringBuffer('[$timestamp] [$level] [$module] $message');
    if (error != null) {
      buffer.write('\n$error');
    }
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    return buffer.toString();
  }

  /// Formats a [DateTime] as `yyyy-MM-dd HH:mm:ss`.
  static String _formatTimestamp(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min:$s';
  }

  /// Core logging method that delegates to the appropriate output sink.
  static void _log(
    String level,
    String module,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final formatted = formatMessage(level, module, message, error, stackTrace);

    if (kDebugMode) {
      // Requirement 1.3 – debug mode: dart:developer log()
      developer.log(
        formatted,
        name: module,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // Requirement 1.4 – release mode: append to date-named log file
      _writeToFile(formatted);
    }
  }

  /// Appends [line] to today's log file.
  ///
  /// Requirement 1.6 – any I/O failure is silently ignored so that
  /// logging never disrupts the application.
  static Future<void> _writeToFile(String line) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final logsDir = Directory('${dir.path}/logs');
      if (!logsDir.existsSync()) {
        logsDir.createSync(recursive: true);
      }

      final now = DateTime.now();
      final fileName =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
      final file = File('${logsDir.path}/$fileName');
      file.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
    } catch (_) {
      // Requirement 1.6 – silently ignore write failures.
    }
  }
}
