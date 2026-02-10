import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:test_app3/core/providers/app_providers.dart';
import 'package:test_app3/core/widgets/mesh_gradient_bg.dart';
import 'package:test_app3/core/widgets/theme_switcher.dart';
import 'package:test_app3/core/theme/app_colors.dart';
import 'nav_rail.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _checkMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _checkMaximized() async {
    final m = await windowManager.isMaximized();
    if (mounted) setState(() => _isMaximized = m);
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  @override
  Widget build(BuildContext context) {
    final isMac = ref.watch(isMacProvider);

    return ThemeSwitcher(
      key: ThemeSwitcher.globalKey,
      child: _buildShell(context, isMac),
    );
  }

  Widget _buildShell(BuildContext context, bool isMac) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MeshGradientBackground(
      child: Row(
        children: [
          const AppNavRail(),
          Expanded(
            child: Column(
              children: [
                _TitleBar(
                  isMac: isMac,
                  isDark: isDark,
                  isMaximized: _isMaximized,
                ),
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 标题栏 — 可拖拽 + Windows 窗口控制按钮
class _TitleBar extends StatelessWidget {
  const _TitleBar({
    required this.isMac,
    required this.isDark,
    required this.isMaximized,
  });
  final bool isMac;
  final bool isDark;
  final bool isMaximized;

  @override
  Widget build(BuildContext context) {
    final h = isMac ? 38.0 : 44.0;
    return Container(
      height: h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: SizedBox(height: h),
            ),
          ),
          if (!isMac) ...[
            _WindowButton(
              icon: Icons.remove_rounded,
              isDark: isDark,
              onTap: () => windowManager.minimize(),
            ),
            _WindowButton(
              icon: isMaximized
                  ? Icons.filter_none_rounded
                  : Icons.crop_square_rounded,
              isDark: isDark,
              size: isMaximized ? 14 : 16,
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
            ),
            _WindowButton(
              icon: Icons.close_rounded,
              isDark: isDark,
              isClose: true,
              onTap: () => windowManager.close(),
            ),
          ],
        ],
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  const _WindowButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
    this.isClose = false,
    this.size = 16,
  });
  final IconData icon;
  final bool isDark;
  final bool isClose;
  final double size;
  final VoidCallback onTap;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor = widget.isClose
        ? const Color(0xFFE81123)
        : (widget.isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05));

    final iconColor = _hovered && widget.isClose
        ? Colors.white
        : (widget.isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 46,
          height: 44,
          color: _hovered ? hoverColor : Colors.transparent,
          child: Center(
            child: Icon(widget.icon, size: widget.size, color: iconColor),
          ),
        ),
      ),
    );
  }
}
