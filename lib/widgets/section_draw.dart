import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'tile_widget.dart';

class SectionDraw extends StatefulWidget {
  const SectionDraw({super.key});

  @override
  State<SectionDraw> createState() => _SectionDrawState();
}

class _SectionDrawState extends State<SectionDraw> {
  List<String> hand = [];
  bool drawing = false;
  int d1 = 3;
  int d2 = 5;
  bool rolling = false;

  final drawPool = [
    'wan-3', 'bing-7', 'tiao-5', 'east', 'wan-8', 'bing-2',
    'tiao-2', 'red', 'wan-5', 'bing-5', 'south', 'tiao-9',
    'green', 'wan-1', 'bing-9', 'tiao-4', 'west', 'wan-6',
  ];

  int get maxHand => globalRulesetNotifier.value == Ruleset.taiwan ? 17 : 14;
  int get total => d1 + d2;
  String get breakSeat {
    final seats = ['east', 'south', 'west', 'north'];
    return seats[(total - 1) % 4];
  }

  void doDraw() {
    if (drawing || hand.length >= maxHand) return;
    setState(() => drawing = true);
    final next = drawPool[hand.length % drawPool.length];
    Future.delayed(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() {
        hand = [...hand, next];
        drawing = false;
      });
    });
  }

  void resetHand() => setState(() => hand = []);

  void rollDice() {
    if (rolling) return;
    setState(() => rolling = true);
    var ticks = 0;
    final timer = Stream.periodic(const Duration(milliseconds: 60), (i) => i).take(10);
    timer.listen((_) {
      if (!mounted) return;
      setState(() {
        d1 = 1 + (DateTime.now().millisecond % 6);
        d2 = 1 + ((DateTime.now().millisecond + 100) % 6);
      });
    }, onDone: () {
      if (!mounted) return;
      setState(() => rolling = false);
    });
  }

  static const diceFaces = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);
    final sorted = hand.length == maxHand;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 60),
          _buildDiceSection(theme),
          const SizedBox(height: 40),
          _buildWallSection(theme),
          const SizedBox(height: 40),
          _buildDrawSection(theme, sorted),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section 03 · The wall',
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How do you draw tiles?',
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
          'Tiles are stacked into a square wall in the center of the table. Players draw from the wall in turn, going counter-clockwise. The dealer rolls dice to decide where to break the wall.',
          style: GoogleFonts.sourceSerif4(
            fontSize: 20,
            height: 1.55,
            color: theme.inkSoft,
          ),
        ),
      ],
    );
  }

  Widget _buildDiceSection(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. Roll to break the wall',
            style: GoogleFonts.sourceSerif4(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: theme.ink,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                diceFaces[d1 - 1],
                style: GoogleFonts.ibmPlexMono(fontSize: 48, color: theme.ink),
              ),
              const SizedBox(width: 16),
              Text(
                diceFaces[d2 - 1],
                style: GoogleFonts.ibmPlexMono(fontSize: 48, color: theme.ink),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total: $total',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Break at: ${breakSeat.toUpperCase()} wall, $total stacks from right',
                    style: GoogleFonts.inter(fontSize: 14, color: theme.inkSoft),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: rollDice,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.jade,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                rolling ? 'Rolling...' : 'Roll dice',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWallSection(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2. The wall',
            style: GoogleFonts.sourceSerif4(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: theme.ink,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: theme.wallFelt,
                border: Border.all(color: theme.wallFeltEdge),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Simplified wall representation
                  Center(
                    child: Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      alignment: WrapAlignment.center,
                      children: List.generate(34, (i) {
                        return Container(
                          width: 24,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.wallTile,
                            border: Border.all(color: theme.wallTileEdge),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Direction labels
                  Positioned(top: 8, left: 0, right: 0, child: Center(child: _dirLabel('北 N', theme))),
                  Positioned(bottom: 8, left: 0, right: 0, child: Center(child: _dirLabel('南 S', theme))),
                  Positioned(left: 8, top: 0, bottom: 0, child: Center(child: _dirLabel('西 W', theme))),
                  Positioned(right: 8, top: 0, bottom: 0, child: Center(child: _dirLabel('東 E', theme))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dirLabel(String text, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.wallArrow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: theme.wallArrowGlyph,
        ),
      ),
    );
  }

  Widget _buildDrawSection(AppTheme theme, bool sorted) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3. Draw your hand',
            style: GoogleFonts.sourceSerif4(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: theme.ink,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to draw tiles one by one. When you have $maxHand tiles, your hand is sorted automatically.',
            style: GoogleFonts.sourceSerif4(fontSize: 16, color: theme.inkSoft),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: hand.map((tileId) {
              return TileWidget(id: tileId, size: TileSize.sm);
            }).toList(),
          ),
          if (sorted)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Hand sorted!',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.jade,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: hand.length >= maxHand || drawing ? null : doDraw,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: hand.length >= maxHand || drawing ? theme.ruleSoft : theme.jade,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    drawing
                        ? 'Drawing...'
                        : hand.length >= maxHand
                            ? 'Hand complete'
                            : 'Draw tile (${hand.length}/$maxHand)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: hand.length >= maxHand || drawing ? theme.inkMuted : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: hand.isEmpty ? null : resetHand,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.rule),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: hand.isEmpty ? theme.inkMuted : theme.inkSoft,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
