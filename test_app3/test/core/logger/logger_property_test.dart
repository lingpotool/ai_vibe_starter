/// Property-based tests for AppLogger formatting.
///
/// **Validates: Requirements 1.1, 1.2, 1.5**
///
/// Property 1: 日志格式化一致性 (Log Formatting Consistency)
///
/// *For any* log level (INFO/WARN/ERROR), any module name and any message
/// string, Logger's formatted output SHALL contain `[timestamp]` (ISO 8601
/// format), `[level]`, `[module]` and message content. When level is ERROR
/// and an exception object is passed, output SHALL also contain exception
/// message and stack trace string.
import 'package:glados/glados.dart';
import 'package:test_app3/core/logger/logger.dart';

/// Custom generator for log levels.
extension LogLevelAny on Any {
  Generator<String> get logLevel => choose(['INFO', 'WARN', 'ERROR']);
}

void main() {
  group('Property 1: 日志格式化一致性', () {
    /// **Validates: Requirements 1.1, 1.2, 1.5**

    Glados2(any.logLevel, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'formatted output contains [LEVEL] tag for any level and module',
      (String level, String module) {
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          level,
          module,
          'test message',
        );

        expect(result, contains('[$level]'));
      },
    );

    Glados2(any.logLevel, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'formatted output contains [module] tag for any level and module',
      (String level, String module) {
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          level,
          module,
          'test message',
        );

        expect(result, contains('[$module]'));
      },
    );

    Glados3(any.logLevel, any.letterOrDigits, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'formatted output contains the message content',
      (String level, String module, String message) {
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          level,
          module,
          message,
        );

        expect(result, contains(message));
      },
    );

    Glados(any.logLevel, ExploreConfig(numRuns: 100)).test(
      'formatted output starts with timestamp in [yyyy-MM-dd HH:mm:ss] format',
      (String level) {
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          level,
          'mod',
          'msg',
        );

        expect(
          result,
          startsWith('[2025-06-15 12:30:45]'),
        );
      },
    );

    Glados2(any.letterOrDigits, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'timestamp format matches [yyyy-MM-dd HH:mm:ss] pattern with formatMessage',
      (String module, String message) {
        final result = AppLogger.formatMessage(
          'INFO',
          module,
          message,
        );

        // Verify the output starts with a timestamp in the expected format
        expect(
          result,
          matches(RegExp(
            r'^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]',
          )),
        );
      },
    );

    Glados2(any.letterOrDigits, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'ERROR level with exception object includes error string in output',
      (String module, String message) {
        final errorMessage = 'Something went wrong: $message';
        final exception = Exception(errorMessage);
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);

        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          module,
          message,
          exception,
        );

        expect(result, contains('[ERROR]'));
        expect(result, contains('[$module]'));
        expect(result, contains(message));
        expect(result, contains(errorMessage));
      },
    );

    Glados2(any.letterOrDigits, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'ERROR level with exception and stack trace includes both in output',
      (String module, String message) {
        final exception = Exception('error: $message');
        final stackTrace = StackTrace.current;
        final fixedTime = DateTime(2025, 6, 15, 12, 30, 45);

        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          module,
          message,
          exception,
          stackTrace,
        );

        expect(result, contains('[ERROR]'));
        expect(result, contains('[$module]'));
        expect(result, contains(message));
        expect(result, contains(exception.toString()));
        expect(result, contains(stackTrace.toString()));
      },
    );
  });
}
