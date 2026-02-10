import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app3/core/layout/app_shell.dart';
import 'package:test_app3/core/router/app_route_observer.dart';
import 'package:test_app3/core/router/not_found_page.dart';
import 'package:test_app3/features/home/home_page.dart';
import 'package:test_app3/features/settings/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  observers: [AppRouteObserver()],
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const HomePage(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SettingsPage(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
      ],
    ),
  ],
);

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.01),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    ),
  );
}
