import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/router/app_route_observer.dart';

/// A minimal [Route] stub for testing the observer.
class _FakeRoute extends PageRoute<void> {
  _FakeRoute(this._name);

  final String? _name;

  @override
  RouteSettings get settings => RouteSettings(name: _name);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('AppRouteObserver', () {
    late AppRouteObserver observer;

    setUp(() {
      observer = AppRouteObserver();
    });

    test('didPush does not throw', () {
      final route = _FakeRoute('/home');
      final previousRoute = _FakeRoute('/settings');

      // Should not throw when called
      expect(
        () => observer.didPush(route, previousRoute),
        returnsNormally,
      );
    });

    test('didPop does not throw', () {
      final route = _FakeRoute('/settings');
      final previousRoute = _FakeRoute('/home');

      expect(
        () => observer.didPop(route, previousRoute),
        returnsNormally,
      );
    });

    test('didPush handles null previousRoute', () {
      final route = _FakeRoute('/home');

      expect(
        () => observer.didPush(route, null),
        returnsNormally,
      );
    });

    test('didPop handles null previousRoute', () {
      final route = _FakeRoute('/home');

      expect(
        () => observer.didPop(route, null),
        returnsNormally,
      );
    });

    test('didPush handles route with null name', () {
      final route = _FakeRoute(null);
      final previousRoute = _FakeRoute('/home');

      expect(
        () => observer.didPush(route, previousRoute),
        returnsNormally,
      );
    });

    test('didPop handles route with null name', () {
      final route = _FakeRoute(null);
      final previousRoute = _FakeRoute('/home');

      expect(
        () => observer.didPop(route, previousRoute),
        returnsNormally,
      );
    });
  });
}
