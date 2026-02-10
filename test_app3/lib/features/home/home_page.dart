import 'package:flutter/material.dart';
import 'package:test_app3/l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app3/core/widgets/glass.dart';
import 'package:test_app3/core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return ListView(
      padding: const EdgeInsets.only(top: 4),
      children: [
        // 限制内容最大宽度
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Text(
                  '${l10n.welcome} ${l10n.appName}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: fg,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.appDescription,
                        style: TextStyle(fontSize: 13, color: mutedFg, height: 1.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: isDark ? 0.06 : 0.04),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: border),
                      ),
                      child: Text(
                        'v0.1.0',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: mutedFg,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Stats Grid ──
                LayoutBuilder(
                  builder: (context, constraints) {
                    final spacing = 12.0;
                    final cardWidth = (constraints.maxWidth - spacing * 3) / 4;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        _StatCard(width: cardWidth, label: l10n.activeToday, value: '1,234', icon: LucideIcons.activity, color: const Color(0xFF3B82F6)),
                        _StatCard(width: cardWidth, label: l10n.totalTasks, value: '56', icon: LucideIcons.checkSquare, color: const Color(0xFF10B981)),
                        _StatCard(width: cardWidth, label: l10n.completion, value: '89%', icon: LucideIcons.checkCircle, color: const Color(0xFF8B5CF6)),
                        _StatCard(width: cardWidth, label: l10n.pending, value: '12', icon: LucideIcons.clock, color: const Color(0xFFF59E0B)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // ── Quick Start ──
                GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                        child: Text(
                          l10n.quickStart,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: fg,
                          ),
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: border),
                      // Steps
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          children: [
                            _StepRow(n: 1, text: l10n.step1, code: 'lib/features/', primary: primary, fg: fg, mutedFg: mutedFg, isDark: isDark),
                            const SizedBox(height: 14),
                            _StepRow(n: 2, text: l10n.step2, code: 'router.dart', primary: primary, fg: fg, mutedFg: mutedFg, isDark: isDark),
                            const SizedBox(height: 14),
                            _StepRow(n: 3, text: l10n.step3, code: null, primary: primary, fg: fg, mutedFg: mutedFg, isDark: isDark),
                            const SizedBox(height: 14),
                            _StepRow(n: 4, text: l10n.step4, code: null, primary: primary, fg: fg, mutedFg: mutedFg, isDark: isDark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 统计卡片 — 固定宽度，hover 微上浮
class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.width,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.darkCardForeground : AppColors.lightCardForeground;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -1 : 0, 0),
        width: widget.width,
        child: GlassContainer(
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: mutedFg,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: isDark ? 0.06 : 0.04),
                    ),
                    child: Icon(widget.icon, size: 14, color: widget.color),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 步骤行
class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.n,
    required this.text,
    this.code,
    required this.primary,
    required this.fg,
    required this.mutedFg,
    required this.isDark,
  });
  final int n;
  final String text;
  final String? code;
  final Color primary;
  final Color fg;
  final Color mutedFg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: isDark ? 0.15 : 0.1),
          ),
          child: Center(
            child: Text(
              '$n',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: text,
                    style: TextStyle(fontSize: 13, color: mutedFg, height: 1.5),
                  ),
                  if (code != null) ...[
                    const TextSpan(text: '  '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: isDark ? 0.06 : 0.04),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          code!,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: fg,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
