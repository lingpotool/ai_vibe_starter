import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Structured logging service.
class AppLogger {
  AppLogger._();

  static void info(String module, String message) {
    _log('INFO', module, message);
  }

  static void warn(String module, String message) {
    _log('WARN', module, message);
  }

  static void error(String module, String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', module, message, error, stackTrace);
  }

  static String formatMessage(String level, String module, String message,
      [Object? error, StackTrace? stackTrace]) {
    final timestamp = _formatTimestamp(DateTime.now());
    return _formatMessageWithTimestamp(timestamp, level, module, message, error, stackTrace);
  }

  @visibleForTesting
  static String formatMessageWithTimestamp(DateTime timestamp, String level,
      String module, String message, [Object? error, StackTrace? stackTrace]) {
    return _formatMessageWithTimestamp(
        _formatTimestamp(timestamp), level, module, message, error, stackTrace);
  }

  static String _formatMessageWithTimestamp(String timestamp, String level,
      String module, String message, [Object? error, StackTrace? stackTrace]) {
    final buffer = StringBuffer('[$timestamp] [$level] [$module] $message');
    if (error != null) buffer.write('\n$error');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    return buffer.toString();
  }

  static String _formatTimestamp(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min:$s';
  }

  static void _log(String level, String module, String message,
      [Object? error, StackTrace? stackTrace]) {
    final formatted = formatMessage(level, module, message, error, stackTrace);
    if (kDebugMode) {
      developer.log(formatted, name: module, error: error, stackTrace: stackTrace);
    } else {
      _writeToFile(formatted);
    }
  }

  static Future<void> _writeToFile(String line) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final logsDir = Directory('${dir.path}/logs');
      if (!logsDir.existsSync()) logsDir.createSync(recursive: true);
      final now = DateTime.now();
      final fileName =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
      final file = File('${logsDir.path}/$fileName');
      file.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
    } catch (_) {}
  }
}
