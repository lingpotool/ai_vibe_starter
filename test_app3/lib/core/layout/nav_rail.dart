import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app3/core/providers/app_providers.dart';
import 'package:test_app3/core/theme/app_colors.dart';
import 'package:test_app3/core/widgets/theme_switcher.dart';

class _NavItem {
  final String path;
  final IconData icon;
  final String tooltip;
  const _NavItem(this.path, this.icon, this.tooltip);
}

const _navItems = [
  _NavItem('/home', LucideIcons.home, '首页'),
  _NavItem('/settings', LucideIcons.settings, '设置'),
];

/// 56px 窄侧边栏 — 玻璃态
class AppNavRail extends ConsumerStatefulWidget {
  const AppNavRail({super.key});

  @override
  ConsumerState<AppNavRail> createState() => _AppNavRailState();
}

class _AppNavRailState extends ConsumerState<AppNavRail> {
  OverlayEntry? _tooltipEntry;

  void _showTooltip(BuildContext itemContext, String text) {
    _hideTooltip();
    final box = itemContext.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset(box.size.width + 8, box.size.height / 2 - 14));

    _tooltipEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: pos.dx,
        top: pos.dy,
        child: _GlassTooltip(text: text),
      ),
    );
    Overlay.of(context).insert(_tooltipEntry!);
  }

  void _hideTooltip() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMac = ref.watch(isMacProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPath = GoRouterState.of(context).uri.path;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSidebar : AppColors.lightSidebar,
            border: Border(
              right: BorderSide(
                color: isDark ? AppColors.darkSidebarBorder : AppColors.lightSidebarBorder,
              ),
            ),
          ),
          child: Column(
            children: [
              // macOS 红绿灯区域
              if (isMac) const SizedBox(height: 38),
              // Windows titlebar 空间
              if (!isMac) const SizedBox(height: 48),

              // App 图标
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _AppIcon(
                  onTap: () => context.go('/home'),
                  onEnter: (ctx) => _showTooltip(ctx, '首页'),
                  onExit: _hideTooltip,
                ),
              ),

              // 分割线
              Container(
                width: 24,
                height: 1,
                margin: const EdgeInsets.only(bottom: 8),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06),
              ),

              // 导航项
              ..._navItems.map((item) => _NavButton(
                    icon: item.icon,
                    isActive: currentPath == item.path,
                    onTap: () => context.go(item.path),
                    onEnter: (ctx) => _showTooltip(ctx, item.tooltip),
                    onExit: _hideTooltip,
                  )),

              const Spacer(),

              // 主题切换
              _ThemeToggle(
                isDark: isDark,
                onTapWithPosition: (globalPos) {
                  ThemeSwitcher.globalKey.currentState
                      ?.toggleTheme(globalPos);
                },
                onEnter: (ctx) => _showTooltip(ctx, isDark ? 'Light mode' : 'Dark mode'),
                onExit: _hideTooltip,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.onTap, required this.onEnter, required this.onExit});
  final VoidCallback onTap;
  final void Function(BuildContext) onEnter;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(context),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B5EF6).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(LucideIcons.zap, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
  });
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final void Function(BuildContext) onEnter;
  final VoidCallback onExit;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          widget.onEnter(context);
        },
        onExit: (_) {
          setState(() => _hovered = false);
          widget.onExit();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.isActive || _hovered
                      ? (isDark ? AppColors.darkSidebarAccent : AppColors.lightSidebarAccent)
                      : Colors.transparent,
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isActive || _hovered
                      ? (isDark ? AppColors.darkForeground : AppColors.lightForeground)
                      : (isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
                ),
              ),
              // 激活指示条
              if (widget.isActive)
                Positioned(
                  left: -7,
                  top: 10,
                  child: Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle({
    required this.isDark,
    required this.onTapWithPosition,
    required this.onEnter,
    required this.onExit,
  });
  final bool isDark;
  final void Function(Offset globalPosition) onTapWithPosition;
  final void Function(BuildContext) onEnter;
  final VoidCallback onExit;

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onEnter(context);
      },
      onExit: (_) {
        setState(() => _hovered = false);
        widget.onExit();
      },
      child: GestureDetector(
        onTapUp: (details) => widget.onTapWithPosition(details.globalPosition),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _hovered
                ? (widget.isDark ? AppColors.darkSidebarAccent : AppColors.lightSidebarAccent)
                : Colors.transparent,
          ),
          child: Icon(
            widget.isDark ? LucideIcons.sun : LucideIcons.moon,
            size: 16,
            color: _hovered
                ? (widget.isDark ? AppColors.darkForeground : AppColors.lightForeground)
                : (widget.isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
          ),
        ),
      ),
    );
  }
}

class _GlassTooltip extends StatelessWidget {
  const _GlassTooltip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 12,
        decoration: TextDecoration.none,
        color: isDark ? AppColors.darkForeground : AppColors.lightForeground,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
