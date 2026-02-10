/// Property-based tests for AppRouteObserver navigation logging.
///
/// **Validates: Requirements 9.1**
///
/// Property 7: RouteObserver 记录导航
///
/// *For any* route navigation event (push or pop), RouteObserver SHALL log
/// an entry via Logger containing both the source path and destination path.
import 'package:flutter/widgets.dart';
import 'package:glados/glados.dart';
import 'package:test_app3/core/router/app_route_observer.dart';

/// A minimal [Route] implementation for testing purposes.
///
/// Wraps a [RouteSettings] with a given name so that [AppRouteObserver]
/// can extract the route name via `route.settings.name`.
class _FakeRoute extends Route<dynamic> {
  _FakeRoute(String? name) : super(settings: RouteSettings(name: name));
}

/// Custom generators for route-related strings.
extension RouteGenerators on Any {
  /// Generates non-empty route path strings like "/home", "/settings".
  Generator<String> get routePath {
    return any.letterOrDigits.map((s) => '/${s.isEmpty ? "page" : s}');
  }
}

void main() {
  group('Property 7: RouteObserver 记录导航', () {
    /// **Validates: Requirements 9.1**

    tearDown(() {
      // Reset the test log callback after each test.
      AppRouteObserver.onLog = null;
    });

    // ----------------------------------------------------------------
    // Test: didPush logs entry containing both source and destination
    // ----------------------------------------------------------------
    Glados2(any.routePath, any.routePath, ExploreConfig(numRuns: 100)).test(
      'didPush logs entry containing both source and destination paths',
      (String fromPath, String toPath) {
        final observer = AppRouteObserver();
        final previousRoute = _FakeRoute(fromPath);
        final newRoute = _FakeRoute(toPath);

        // Capture log messages via the test hook.
        final capturedMessages = <String>[];
        AppRouteObserver.onLog = (module, message) {
          capturedMessages.add(message);
        };

        // Trigger the push navigation event.
        observer.didPush(newRoute, previousRoute);

        // Verify exactly one log entry was produced.
        expect(capturedMessages, hasLength(1),
            reason: 'didPush should produce exactly one log entry');

        final logMessage = capturedMessages.first;

        // Verify the log entry contains the source path.
        expect(logMessage, contains(fromPath),
            reason:
                'Push log entry should contain source path "$fromPath", '
                'but got: "$logMessage"');

        // Verify the log entry contains the destination path.
        expect(logMessage, contains(toPath),
            reason:
                'Push log entry should contain destination path "$toPath", '
                'but got: "$logMessage"');
      },
    );

    // ----------------------------------------------------------------
    // Test: didPop logs entry containing both source and destination
    // ----------------------------------------------------------------
    Glados2(any.routePath, any.routePath, ExploreConfig(numRuns: 100)).test(
      'didPop logs entry containing both source and destination paths',
      (String currentPath, String previousPath) {
        final observer = AppRouteObserver();
        final currentRoute = _FakeRoute(currentPath);
        final previousRoute = _FakeRoute(previousPath);

        // Capture log messages via the test hook.
        final capturedMessages = <String>[];
        AppRouteObserver.onLog = (module, message) {
          capturedMessages.add(message);
        };

        // Trigger the pop navigation event.
        observer.didPop(currentRoute, previousRoute);

        // Verify exactly one log entry was produced.
        expect(capturedMessages, hasLength(1),
            reason: 'didPop should produce exactly one log entry');

        final logMessage = capturedMessages.first;

        // Verify the log entry contains the source path (current route).
        expect(logMessage, contains(currentPath),
            reason:
                'Pop log entry should contain source path "$currentPath", '
                'but got: "$logMessage"');

        // Verify the log entry contains the destination path (previous route).
        expect(logMessage, contains(previousPath),
            reason:
                'Pop log entry should contain destination path "$previousPath", '
                'but got: "$logMessage"');
      },
    );

    // ----------------------------------------------------------------
    // Test: didPush with null previousRoute logs 'unknown' as source
    // ----------------------------------------------------------------
    Glados(any.routePath, ExploreConfig(numRuns: 100)).test(
      'didPush with null previousRoute logs "unknown" as source path',
      (String toPath) {
        final observer = AppRouteObserver();
        final newRoute = _FakeRoute(toPath);

        final capturedMessages = <String>[];
        AppRouteObserver.onLog = (module, message) {
          capturedMessages.add(message);
        };

        // Push with no previous route (initial navigation).
        observer.didPush(newRoute, null);

        expect(capturedMessages, hasLength(1));
        final logMessage = capturedMessages.first;

        // Source should be 'unknown' when previousRoute is null.
        expect(logMessage, contains('unknown'),
            reason:
                'Push log should contain "unknown" when previousRoute is null');
        expect(logMessage, contains(toPath),
            reason:
                'Push log should contain destination path "$toPath"');
      },
    );

    // ----------------------------------------------------------------
    // Test: didPop with null previousRoute logs 'unknown' as destination
    // ----------------------------------------------------------------
    Glados(any.routePath, ExploreConfig(numRuns: 100)).test(
      'didPop with null previousRoute logs "unknown" as destination path',
      (String currentPath) {
        final observer = AppRouteObserver();
        final currentRoute = _FakeRoute(currentPath);

        final capturedMessages = <String>[];
        AppRouteObserver.onLog = (module, message) {
          capturedMessages.add(message);
        };

        // Pop with no previous route.
        observer.didPop(currentRoute, null);

        expect(capturedMessages, hasLength(1));
        final logMessage = capturedMessages.first;

        // Source should be the current route path.
        expect(logMessage, contains(currentPath),
            reason:
                'Pop log should contain source path "$currentPath"');
        // Destination should be 'unknown' when previousRoute is null.
        expect(logMessage, contains('unknown'),
            reason:
                'Pop log should contain "unknown" when previousRoute is null');
      },
    );

    // ----------------------------------------------------------------
    // Test: log module is always 'router'
    // ----------------------------------------------------------------
    Glados2(any.routePath, any.routePath, ExploreConfig(numRuns: 100)).test(
      'navigation logs are always tagged with "router" module',
      (String fromPath, String toPath) {
        final observer = AppRouteObserver();
        final previousRoute = _FakeRoute(fromPath);
        final newRoute = _FakeRoute(toPath);

        final capturedModules = <String>[];
        AppRouteObserver.onLog = (module, message) {
          capturedModules.add(module);
        };

        // Test both push and pop.
        observer.didPush(newRoute, previousRoute);
        observer.didPop(newRoute, previousRoute);

        expect(capturedModules, hasLength(2));
        for (final module in capturedModules) {
          expect(module, equals('router'),
              reason: 'All navigation logs should use "router" module tag');
        }
      },
    );
  });
}
