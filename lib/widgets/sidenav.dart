import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/sections.dart';

class Sidenav extends StatelessWidget {
  final String activeSection;
  final void Function(int) onNavigate;
  final ThemeNotifier themeNotifier;
  final RulesetNotifier rulesetNotifier;

  const Sidenav({
    super.key,
    required this.activeSection,
    required this.onNavigate,
    required this.themeNotifier,
    required this.rulesetNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeId>(
      valueListenable: themeNotifier,
      builder: (context, themeId, _) {
        final theme = AppTheme.byId(themeId);
        return ValueListenableBuilder<Ruleset>(
          valueListenable: rulesetNotifier,
          builder: (context, ruleset, _) {
            return Container(
              width: 280,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: theme.ruleSoft, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBrand(theme),
                  const SizedBox(height: 24),
                  _buildNav(theme),
                  const SizedBox(height: 24),
                  _buildDivider(theme),
                  const SizedBox(height: 20),
                  _buildThemePicker(theme),
                  const SizedBox(height: 24),
                  _buildDivider(theme),
                  const SizedBox(height: 20),
                  _buildRulesetPicker(theme),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBrand(AppTheme theme) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/tiles/modal-tile.svg',
          height: 28,
          width: 28,
        ),
        const SizedBox(width: 10),
        Text(
          'Mahjong ',
          style: GoogleFonts.sourceSerif4(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: theme.inkMuted,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          '麻將',
          style: GoogleFonts.sourceSerif4(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
      ],
    );
  }

  Widget _buildNav(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final s = entry.value;
        final isActive = activeSection == s.id;
        return InkWell(
          onTap: () => onNavigate(index),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? theme.jadeWash : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  s.num,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? theme.jade : theme.inkMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  s.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive ? theme.jade : theme.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDivider(AppTheme theme) {
    return Divider(color: theme.rule, height: 1);
  }

  Widget _buildThemePicker(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: theme.inkMuted,
          ),
        ),
        const SizedBox(height: 6),
        ...AppThemeId.values.map((t) {
          final tTheme = AppTheme.byId(t);
          final isActive = themeNotifier.value == t;
          return _PickerButton(
            label: tTheme.label,
            isActive: isActive,
            theme: theme,
            onTap: () => themeNotifier.setTheme(t),
          );
        }),
      ],
    );
  }

  Widget _buildRulesetPicker(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ruleset',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: theme.inkMuted,
          ),
        ),
        const SizedBox(height: 6),
        _PickerButton(
          label: 'Hong Kong',
          isActive: rulesetNotifier.value == Ruleset.hk,
          theme: theme,
          onTap: () => rulesetNotifier.setRuleset(Ruleset.hk),
        ),
        _PickerButton(
          label: 'Taiwan',
          isActive: rulesetNotifier.value == Ruleset.taiwan,
          theme: theme,
          onTap: () => rulesetNotifier.setRuleset(Ruleset.taiwan),
        ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final AppTheme theme;
  final VoidCallback onTap;

  const _PickerButton({
    required this.label,
    required this.isActive,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? theme.paper : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.ink.withOpacity(0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isActive ? theme.ink : theme.inkMuted,
          ),
        ),
      ),
    );
  }
}
