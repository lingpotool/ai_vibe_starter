import 'package:flutter/foundation.dart';
import '../logger/logger.dart';

/// Global error handler that captures all uncaught exceptions.
class ErrorHandler {
  ErrorHandler._();
  static const String _module = 'error_handler';

  static void init() {
    FlutterError.onError = _handleFlutterError;
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    AppLogger.error(
      _module,
      'FlutterError: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  }

  static bool _handlePlatformError(Object error, StackTrace stack) {
    AppLogger.error(
      _module,
      'PlatformError: ${error.runtimeType} - $error',
      error,
      stack,
    );
    return true;
  }
}
