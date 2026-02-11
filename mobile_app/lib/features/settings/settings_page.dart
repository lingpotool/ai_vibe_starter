import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/providers/app_providers.dart';
import 'package:mobile_app/core/widgets/glass.dart';
import 'package:mobile_app/core/theme/app_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(localeProvider);
    final platform = ref.watch(platformProvider);

    final fg = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        // ── Page Header ──
        Text(
          l10n.settings,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: fg, height: 1.3),
        ),
        const SizedBox(height: 6),
        Text(l10n.appearance, style: TextStyle(fontSize: 13, color: mutedFg)),
        const SizedBox(height: 28),
        // ── Appearance Section ──
        _SectionHeader(icon: LucideIcons.palette, title: l10n.appearance, isDark: isDark),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: BorderRadius.circular(12),
          child: Column(children: [
            _SettingsTile(
              icon: isDark ? LucideIcons.moon : LucideIcons.sun,
              iconColor: const Color(0xFF8B5CF6),
              title: l10n.darkMode,
              subtitle: l10n.darkModeDesc,
              isDark: isDark,
              trailing: _ToggleSwitch(
                value: isDark,
                activeColor: primary,
                onChanged: (_) => ref.read(isDarkProvider.notifier).toggle(),
              ),
            ),
            _TileDivider(color: border),
            _SettingsTile(
              icon: LucideIcons.globe,
              iconColor: const Color(0xFF3B82F6),
              title: l10n.language,
              subtitle: l10n.languageDesc,
              isDark: isDark,
              trailing: _LanguageSelector(
                value: locale.languageCode,
                isDark: isDark,
                onChanged: (code) => ref.read(localeProvider.notifier).set(Locale(code)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 28),

        // ── About Section ──
        _SectionHeader(icon: LucideIcons.info, title: l10n.about, isDark: isDark),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: BorderRadius.circular(12),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3B82F6), Color(0xFF6366F1)]),
                  ),
                  child: const Icon(LucideIcons.zap, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppConfig.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
                  const SizedBox(height: 2),
                  Text(AppConfig.description, style: TextStyle(fontSize: 12, color: mutedFg)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: primary.withValues(alpha: isDark ? 0.15 : 0.08)),
                  child: Text('v${AppConfig.version}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'monospace', color: primary)),
                ),
              ]),
            ),
            _TileDivider(color: border),
            _InfoTile(icon: LucideIcons.box, label: 'Flutter', value: '3.38.x', isDark: isDark),
            _TileDivider(color: border),
            _InfoTile(icon: LucideIcons.code2, label: 'Dart', value: Platform.version.split(' ').first, isDark: isDark),
            _TileDivider(color: border),
            _InfoTile(icon: LucideIcons.smartphone, label: l10n.currentPlatform, value: platform, isDark: isDark, highlight: true),
          ]),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title, required this.isDark});
  final IconData icon;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    return Row(children: [
      Icon(icon, size: 14, color: mutedFg),
      const SizedBox(width: 6),
      Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: mutedFg)),
    ]);
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Divider(height: 1, indent: 54, endIndent: 20, thickness: 1, color: color);
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.isDark, required this.trailing});
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool isDark;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: iconColor.withValues(alpha: isDark ? 0.15 : 0.1)),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: fg)),
          const SizedBox(height: 1),
          Text(subtitle, style: TextStyle(fontSize: 12, color: mutedFg)),
        ])),
        const SizedBox(width: 16),
        trailing,
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value, required this.isDark, this.highlight = false});
  final IconData icon;
  final String label, value;
  final bool isDark;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(children: [
        Icon(icon, size: 14, color: mutedFg),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: mutedFg))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: highlight ? primary.withValues(alpha: isDark ? 0.15 : 0.08) : (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.06 : 0.04),
          ),
          child: Text(value, style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: highlight ? FontWeight.w500 : FontWeight.w400, color: highlight ? primary : fg)),
        ),
      ]),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.value, required this.activeColor, required this.onChanged});
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 44, height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: value ? activeColor : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22, height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.value, required this.isDark, required this.onChanged});
  final String value;
  final bool isDark;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.04 : 0.02),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _LangBtn(label: '中文', active: value == 'zh', primary: primary, mutedFg: mutedFg, isDark: isDark, onTap: () => onChanged('zh')),
        Container(width: 1, height: 32, color: border),
        _LangBtn(label: 'EN', active: value == 'en', primary: primary, mutedFg: mutedFg, isDark: isDark, onTap: () => onChanged('en')),
      ]),
    );
  }
}

class _LangBtn extends StatelessWidget {
  const _LangBtn({required this.label, required this.active, required this.primary, required this.mutedFg, required this.isDark, required this.onTap});
  final String label;
  final bool active, isDark;
  final Color primary, mutedFg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        color: active ? primary.withValues(alpha: isDark ? 0.15 : 0.08) : Colors.transparent,
        child: Center(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? primary : mutedFg))),
      ),
    );
  }
}
