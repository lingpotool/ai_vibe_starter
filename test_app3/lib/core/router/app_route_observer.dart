import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app3/core/logger/logger.dart';

/// A [NavigatorObserver] that logs route navigation events via [AppLogger].
///
/// Integrates into GoRouter's `observers` list to record every push and pop
/// with source and destination route information.
///
/// **Validates: Requirement 9.1**
class AppRouteObserver extends NavigatorObserver {
  static const String _module = 'router';

  /// Optional callback for capturing log messages in tests.
  /// When set, log messages are also forwarded to this callback.
  @visibleForTesting
  static void Function(String module, String message)? onLog;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final from = _routeName(previousRoute);
    final to = _routeName(route);
    final message = 'Push: $from → $to';
    AppLogger.info(_module, message);
    onLog?.call(_module, message);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final from = _routeName(route);
    final to = _routeName(previousRoute);
    final message = 'Pop: $from → $to';
    AppLogger.info(_module, message);
    onLog?.call(_module, message);
  }

  /// Extracts a human-readable name from a [Route].
  ///
  /// Returns the route's settings name if available, otherwise `'unknown'`.
  @visibleForTesting
  static String routeName(Route<dynamic>? route) {
    return route?.settings.name ?? 'unknown';
  }

  static String _routeName(Route<dynamic>? route) {
    return routeName(route);
  }
}
