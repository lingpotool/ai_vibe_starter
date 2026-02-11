import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app/core/widgets/mesh_gradient_bg.dart';
import 'package:mobile_app/core/theme/app_colors.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPath = GoRouterState.of(context).uri.path;

    return MeshGradientBackground(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: child,
              ),
            ),
            _BottomNavBar(
              isDark: isDark,
              currentPath: currentPath,
              onTap: (path) => context.go(path),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;
  const _NavItem(this.path, this.icon, this.label);
}

const _navItems = [
  _NavItem('/home', LucideIcons.home, '首页'),
  _NavItem('/settings', LucideIcons.settings, '设置'),
];

/// 底部导航栏 — 毛玻璃风格
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.isDark,
    required this.currentPath,
    required this.onTap,
  });
  final bool isDark;
  final String currentPath;
  final void Function(String path) onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkSidebar : AppColors.lightSidebar;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: bg,
            border: Border(top: BorderSide(color: border)),
          ),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.map((item) {
                final isActive = currentPath == item.path;
                return _NavBarItem(
                  icon: item.icon,
                  label: item.label,
                  isActive: isActive,
                  isDark: isDark,
                  onTap: () => onTap(item.path),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final color = isActive ? primary : mutedFg;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
