import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../logger/logger.dart';

/// Global error handler that captures all uncaught exceptions.
///
/// Call [init] early in `main()` to wire up:
/// - [FlutterError.onError] – catches Flutter framework exceptions (Req 2.1)
/// - [PlatformDispatcher.instance.onError] – catches platform exceptions (Req 2.2)
///
/// The caller is also expected to wrap `runApp` with `runZonedGuarded`
/// to catch asynchronous exceptions in the zone (Req 2.3).
///
/// All captured errors are logged via [AppLogger.error] with error type,
/// message, and stack trace (Req 2.4).
class ErrorHandler {
  // Private constructor – all members are static.
  ErrorHandler._();

  static const String _module = 'error_handler';

  /// Initialises global error hooks.
  ///
  /// Must be called after [WidgetsFlutterBinding.ensureInitialized].
  static void init() {
    // Requirement 2.1 – capture Flutter framework exceptions
    FlutterError.onError = _handleFlutterError;

    // Requirement 2.2 – capture platform-level exceptions
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  /// Handles errors reported by the Flutter framework.
  static void _handleFlutterError(FlutterErrorDetails details) {
    // Requirement 2.4 – log error type, message, and stack trace
    AppLogger.error(
      _module,
      'FlutterError: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  }

  /// Handles errors reported by the platform dispatcher.
  ///
  /// Returns `true` to indicate the error has been handled.
  static bool _handlePlatformError(Object error, StackTrace stack) {
    // Requirement 2.4 – log error type, message, and stack trace
    AppLogger.error(
      _module,
      'PlatformError: ${error.runtimeType} - $error',
      error,
      stack,
    );
    return true;
  }
}
