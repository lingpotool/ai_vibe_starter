import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/logger/logger.dart';

void main() {
  group('AppLogger', () {
    group('formatMessageWithTimestamp', () {
      final fixedTime = DateTime(2025, 1, 15, 10, 30, 0);

      test('formats INFO message with correct structure', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'INFO',
          'storage',
          'File saved successfully',
        );

        expect(
          result,
          '[2025-01-15 10:30:00] [INFO] [storage] File saved successfully',
        );
      });

      test('formats WARN message with correct structure', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'WARN',
          'network',
          'Connection timeout',
        );

        expect(
          result,
          '[2025-01-15 10:30:00] [WARN] [network] Connection timeout',
        );
      });

      test('formats ERROR message with correct structure', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          'auth',
          'Login failed',
        );

        expect(
          result,
          '[2025-01-15 10:30:00] [ERROR] [auth] Login failed',
        );
      });

      test('includes exception info when error object is provided', () {
        final exception = Exception('Something went wrong');
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          'database',
          'Query failed',
          exception,
        );

        expect(result, contains('[2025-01-15 10:30:00] [ERROR] [database] Query failed'));
        expect(result, contains('Something went wrong'));
      });

      test('includes stack trace when provided', () {
        final exception = Exception('Disk full');
        final stackTrace = StackTrace.current;
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          'storage',
          'Write failed',
          exception,
          stackTrace,
        );

        expect(result, contains('[2025-01-15 10:30:00] [ERROR] [storage] Write failed'));
        expect(result, contains('Disk full'));
        expect(result, contains(stackTrace.toString()));
      });

      test('does not include error/stacktrace lines when not provided', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'INFO',
          'app',
          'Started',
        );

        // Should be a single line with no newlines
        expect(result.contains('\n'), isFalse);
      });

      test('handles empty module name', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'INFO',
          '',
          'Hello',
        );

        expect(result, '[2025-01-15 10:30:00] [INFO] [] Hello');
      });

      test('handles empty message', () {
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'WARN',
          'test',
          '',
        );

        expect(result, '[2025-01-15 10:30:00] [WARN] [test] ');
      });

      test('pads single-digit month and day with zeros', () {
        final dt = DateTime(2025, 3, 5, 8, 5, 9);
        final result = AppLogger.formatMessageWithTimestamp(
          dt,
          'INFO',
          'app',
          'test',
        );

        expect(result, startsWith('[2025-03-05 08:05:09]'));
      });

      test('handles error object without stack trace', () {
        final error = StateError('bad state');
        final result = AppLogger.formatMessageWithTimestamp(
          fixedTime,
          'ERROR',
          'core',
          'Unexpected state',
          error,
        );

        expect(result, contains('[ERROR]'));
        expect(result, contains('Bad state: bad state'));
        // No stack trace line
        final lines = result.split('\n');
        expect(lines.length, 2); // message line + error line
      });
    });

    group('formatMessage (uses current time)', () {
      test('produces output matching expected pattern', () {
        final result = AppLogger.formatMessage('INFO', 'test', 'hello');

        // Verify the format pattern: [yyyy-MM-dd HH:mm:ss] [LEVEL] [module] message
        expect(
          result,
          matches(RegExp(
            r'^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\] \[INFO\] \[test\] hello$',
          )),
        );
      });

      test('error format includes exception when provided', () {
        final result = AppLogger.formatMessage(
          'ERROR',
          'mod',
          'fail',
          Exception('oops'),
        );

        expect(result, contains('[ERROR]'));
        expect(result, contains('[mod]'));
        expect(result, contains('oops'));
      });
    });

    group('public API methods', () {
      // These tests verify that info/warn/error don't throw.
      // In debug mode they use dart:developer which we can't easily capture,
      // but we can verify they execute without errors.

      test('info does not throw', () {
        expect(() => AppLogger.info('test', 'info message'), returnsNormally);
      });

      test('warn does not throw', () {
        expect(() => AppLogger.warn('test', 'warn message'), returnsNormally);
      });

      test('error does not throw', () {
        expect(
          () => AppLogger.error('test', 'error message'),
          returnsNormally,
        );
      });

      test('error with exception does not throw', () {
        expect(
          () => AppLogger.error(
            'test',
            'error message',
            Exception('test error'),
          ),
          returnsNormally,
        );
      });

      test('error with exception and stack trace does not throw', () {
        expect(
          () => AppLogger.error(
            'test',
            'error message',
            Exception('test error'),
            StackTrace.current,
          ),
          returnsNormally,
        );
      });
    });
  });
}
