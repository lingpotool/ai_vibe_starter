import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/errors/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    setUp(() {
      // Reset handlers before each test
      FlutterError.onError = FlutterError.dumpErrorToConsole;
      PlatformDispatcher.instance.onError = null;
    });

    test('init() sets FlutterError.onError (Req 2.1)', () {
      final originalHandler = FlutterError.onError;

      ErrorHandler.init();

      // FlutterError.onError should have been replaced
      expect(FlutterError.onError, isNot(equals(originalHandler)));
    });

    test('init() sets PlatformDispatcher.instance.onError (Req 2.2)', () {
      ErrorHandler.init();

      // PlatformDispatcher.instance.onError should be set
      expect(PlatformDispatcher.instance.onError, isNotNull);
    });

    test('FlutterError.onError handler does not throw (Req 2.1, 2.4)', () {
      ErrorHandler.init();

      // Calling the handler with a FlutterErrorDetails should not throw
      final details = FlutterErrorDetails(
        exception: Exception('test flutter error'),
        stack: StackTrace.current,
        library: 'test library',
        context: ErrorDescription('test context'),
      );

      expect(() => FlutterError.onError!(details), returnsNormally);
    });

    test('PlatformDispatcher.onError handler returns true (Req 2.2, 2.4)',
        () {
      ErrorHandler.init();

      final handler = PlatformDispatcher.instance.onError!;
      final result = handler(
        Exception('test platform error'),
        StackTrace.current,
      );

      // Should return true to indicate the error was handled
      expect(result, isTrue);
    });

    test(
        'FlutterError.onError handles error with null stack trace (Req 2.4)',
        () {
      ErrorHandler.init();

      final details = FlutterErrorDetails(
        exception: Exception('error without stack'),
      );

      expect(() => FlutterError.onError!(details), returnsNormally);
    });

    test('PlatformDispatcher.onError handles various error types (Req 2.4)',
        () {
      ErrorHandler.init();

      final handler = PlatformDispatcher.instance.onError!;

      // String error
      expect(handler('string error', StackTrace.current), isTrue);

      // StateError
      expect(handler(StateError('bad state'), StackTrace.current), isTrue);

      // FormatException
      expect(
        handler(const FormatException('bad format'), StackTrace.current),
        isTrue,
      );
    });
  });
}
