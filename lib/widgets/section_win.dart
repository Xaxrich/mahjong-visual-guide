import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/winning_hands.dart';
import 'tile_widget.dart';

class SectionWin extends StatefulWidget {
  const SectionWin({super.key});

  @override
  State<SectionWin> createState() => _SectionWinState();
}

class _SectionWinState extends State<SectionWin> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);
    final ruleset = globalRulesetNotifier.value;
    final hands = ruleset == Ruleset.hk ? winningHandsHk : winningHandsTaiwan;
    final hand = hands[selectedIndex];

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, ruleset),
          const SizedBox(height: 60),
          _buildHandSelector(hands, theme),
          const SizedBox(height: 40),
          _buildHandDisplay(hand, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme, Ruleset ruleset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section 02 · Winning',
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How do you win?',
          style: GoogleFonts.sourceSerif4(
            fontSize: 56,
            height: 1,
            letterSpacing: -1.5,
            fontWeight: FontWeight.w500,
            color: theme.ink,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          ruleset == Ruleset.hk
              ? 'A winning hand has four sets (melds) plus one pair. The pair is called the "eyes." Sets can be either chows (runs of 3 in the same suit) or pungs (triplets of identical tiles).'
              : 'A winning hand has five sets (melds) plus one pair — 17 tiles total. Taiwan rules require at least 1 臺 (a scoring unit) to declare a valid win.',
          style: GoogleFonts.sourceSerif4(
            fontSize: 20,
            height: 1.55,
            color: theme.inkSoft,
          ),
        ),
      ],
    );
  }

  Widget _buildHandSelector(List<WinningHand> hands, AppTheme theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: hands.asMap().entries.map((entry) {
        final index = entry.key;
        final hand = entry.value;
        final isActive = selectedIndex == index;
        return InkWell(
          onTap: () => setState(() => selectedIndex = index),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? theme.jade : theme.paper,
              border: Border.all(
                color: isActive ? theme.jadeDeep : theme.rule,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              hand.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : theme.inkSoft,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHandDisplay(WinningHand hand, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hand.name,
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: theme.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hand.zh,
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 20,
                        color: theme.vermillion,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.jadeWash,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hand.points,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.jade,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...hand.melds.map((meld) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meld.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: theme.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: meld.tiles.map((tileId) {
                      return TileWidget(
                        id: tileId,
                        size: TileSize.sm,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(
            hand.desc,
            style: GoogleFonts.sourceSerif4(
              fontSize: 16,
              height: 1.5,
              color: theme.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
