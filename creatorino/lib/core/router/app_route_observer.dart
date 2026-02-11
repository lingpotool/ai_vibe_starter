import 'package:flutter/widgets.dart';
import 'package:creatorino/core/logger/logger.dart';

class AppRouteObserver extends NavigatorObserver {
  static const String _module = 'router';

  @visibleForTesting
  static void Function(String module, String message)? onLog;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final message = 'Push: ${_routeName(previousRoute)} → ${_routeName(route)}';
    AppLogger.info(_module, message);
    onLog?.call(_module, message);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final message = 'Pop: ${_routeName(route)} → ${_routeName(previousRoute)}';
    AppLogger.info(_module, message);
    onLog?.call(_module, message);
  }

  @visibleForTesting
  static String routeName(Route<dynamic>? route) => route?.settings.name ?? 'unknown';
  static String _routeName(Route<dynamic>? route) => routeName(route);
}
