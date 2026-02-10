import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app3/core/providers/app_providers.dart';

/// Telegram-style circular reveal theme transition.
///
/// Screenshot approach (same as Telegram / React Native / CSS View Transition):
///   1. Screenshot the current UI via RepaintBoundary
///   2. Insert screenshot into Overlay (covers everything)
///   3. Toggle the real theme (UI rebuilds underneath, invisible)
///   4. Animate: clip the screenshot with an inverted circle that grows,
///      revealing the new theme underneath
///   5. Remove overlay when done
class ThemeSwitcher extends ConsumerStatefulWidget {
  const ThemeSwitcher({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ThemeSwitcher> createState() => ThemeSwitcherState();
  static final globalKey = GlobalKey<ThemeSwitcherState>();
}

class ThemeSwitcherState extends ConsumerState<ThemeSwitcher>
    with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();
  late AnimationController _ctrl;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> toggleTheme(Offset tapPosition) async {
    if (_animating) return;

    // Step 1: Capture screenshot of current UI
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 1.0);
    if (!mounted) {
      image.dispose();
      return;
    }

    // Grab overlay and size before any async gap
    final overlay = Overlay.of(context);
    final size = MediaQuery.sizeOf(context);
    final maxRadius = _maxRadius(tapPosition, size);

    // Step 2: Insert screenshot overlay BEFORE toggling theme
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = Curves.easeInOutCubic.transform(_ctrl.value);
          final radius = maxRadius * t;
          return ClipPath(
            clipper: _InvertedCircleClipper(
              center: tapPosition,
              radius: radius,
            ),
            child: IgnorePointer(
              child: RawImage(
                image: image,
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(entry);
    _animating = true;

    // Step 3: Toggle the real theme. UI rebuilds underneath the screenshot.
    ref.read(isDarkProvider.notifier).toggle();

    // Step 4: Wait one frame for the rebuild, then start the reveal animation
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _ctrl.forward(from: 0).then((_) {
        // Step 5: Cleanup
        entry.remove();
        image.dispose();
        _animating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: widget.child,
    );
  }

  static double _maxRadius(Offset o, Size s) {
    return [
      Offset.zero,
      Offset(s.width, 0),
      Offset(0, s.height),
      Offset(s.width, s.height),
    ].map((c) => (c - o).distance).reduce(max);
  }
}

/// Clips EVERYTHING EXCEPT a circle. The circle is the hole that
/// reveals the new theme underneath. As radius grows, more new theme
/// is visible, until the entire old screenshot is clipped away.
class _InvertedCircleClipper extends CustomClipper<Path> {
  _InvertedCircleClipper({required this.center, required this.radius});
  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    final outer = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    return Path.combine(PathOperation.difference, outer, inner);
  }

  @override
  bool shouldReclip(covariant _InvertedCircleClipper old) =>
      old.radius != radius || old.center != center;
}