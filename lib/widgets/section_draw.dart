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

  final seats = ['east', 'south', 'west', 'north'];
  final seatMeta = {
    'east':  {'zh': '東', 'en': 'East',  'nums': '1 · 5 · 9'},
    'south': {'zh': '南', 'en': 'South', 'nums': '2 · 6 · 10'},
    'west':  {'zh': '西', 'en': 'West',  'nums': '3 · 7 · 11'},
    'north': {'zh': '北', 'en': 'North', 'nums': '4 · 8 · 12'},
  };

  String get breakSeat => seats[(total - 1) % 4];
  int get breakStackFromRight => total;

  void rollDice() {
    if (rolling) return;
    setState(() => rolling = true);
    Stream.periodic(const Duration(milliseconds: 60), (i) => i).take(10).listen(
      (_) => setState(() {
        d1 = 1 + (DateTime.now().millisecond % 6);
        d2 = 1 + ((DateTime.now().millisecond + 100) % 6);
      }),
      onDone: () => setState(() => rolling = false),
    );
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

  static const diceFaces = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);
    final isTaiwan = globalRulesetNotifier.value == Ruleset.taiwan;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, isTaiwan),
          const SizedBox(height: 60),
          _buildDealerCard(theme, isTaiwan),
          const SizedBox(height: 40),
          _buildStep1(theme),
          const SizedBox(height: 24),
          _buildStep2(theme),
          const SizedBox(height: 24),
          _buildStep3(theme, isTaiwan),
          const SizedBox(height: 24),
          _buildStep4(theme, isTaiwan),
          const SizedBox(height: 40),
          _buildHand(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme, bool isTaiwan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section 03 · Opening the game',
          style: GoogleFonts.inter(
            fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How do you draw tiles?',
          style: GoogleFonts.sourceSerif4(
            fontSize: 56, height: 1, letterSpacing: -1.5,
            fontWeight: FontWeight.w500, color: theme.ink,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Before the first turn, the ${isTaiwan ? 144 : 136} tiles become a square wall that shrinks as players draw from it. Here\'s the opening ritual — in four steps.',
          style: GoogleFonts.sourceSerif4(
            fontSize: 20, height: 1.55, color: theme.inkSoft,
          ),
        ),
      ],
    );
  }

  Widget _buildDealerCard(AppTheme theme, bool isTaiwan) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper, border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choosing the first dealer',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 18, fontWeight: FontWeight.w500, color: theme.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Each player rolls two dice. The highest total takes the East seat and becomes the first dealer. Ties re-roll between the tied players.',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 15, height: 1.5, color: theme.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 80, color: theme.rule, margin: const EdgeInsets.symmetric(horizontal: 24)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dealer rotation',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 18, fontWeight: FontWeight.w500, color: theme.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isTaiwan
                    ? 'The dealer keeps the East seat as long as they win. When any other player wins, the deal passes counter-clockwise. A drawn hand also keeps the dealer in place.'
                    : 'The dealer keeps the East seat for as long as they keep winning. The moment any other player wins, the deal passes counter-clockwise. A drawn hand also keeps the dealer in place.',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 15, height: 1.5, color: theme.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(AppTheme theme) {
    return _StepCard(
      num: '1',
      title: 'Build the wall',
      desc: 'All 136 tiles are shuffled face-down and stacked two-high in a square. Each side is 17 stacks long — 17 × 2 × 4 = 136.',
      theme: theme,
      child: _WallView(variant: WallVariant.build, theme: theme),
    );
  }

  Widget _buildStep2(AppTheme theme) {
    final meta = seatMeta[breakSeat]!;
    return _StepCard(
      num: '2',
      title: 'Break the wall',
      desc: 'The dealer rolls two dice. The total does two things at once — it picks whose wall to break, and how many stacks in from the right to break it.',
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildBreakRule(theme,
                  title: '① Whose wall?',
                  desc: 'Count the total counter-clockwise starting from the dealer (East = 1).',
                  child: Column(
                    children: seats.map((s) {
                      final m = seatMeta[s]!;
                      final on = s == breakSeat;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: on ? theme.jadeWash : null,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(m['zh']!, style: GoogleFonts.sourceSerif4(
                              fontSize: 14, color: on ? theme.jade : theme.inkSoft, fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                            )),
                            const SizedBox(width: 8),
                            Text(m['en']!, style: GoogleFonts.inter(
                              fontSize: 13, color: on ? theme.jade : theme.inkSoft,
                            )),
                            const Spacer(),
                            Text(m['nums']!, style: GoogleFonts.ibmPlexMono(
                              fontSize: 11, color: on ? theme.jade : theme.inkFaint,
                            )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBreakRule(theme,
                  title: '② Where on it?',
                  desc: 'On that player\'s wall, count the same total in stacks from the right end. That\'s your break point. Tiles to the left are the live wall; to the right, the dead wall.',
                  child: const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: rollDice,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.jade, borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(diceFaces[d1 - 1], style: GoogleFonts.ibmPlexMono(fontSize: 32, color: Colors.white)),
                      const SizedBox(width: 8),
                      Text(diceFaces[d2 - 1], style: GoogleFonts.ibmPlexMono(fontSize: 32, color: Colors.white)),
                      const SizedBox(width: 12),
                      Text('= $total', style: GoogleFonts.ibmPlexMono(
                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white,
                      )),
                      const SizedBox(width: 12),
                      Text(rolling ? 'rolling…' : '↻ roll', style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.white.withOpacity(0.8),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '→ $total lands on ${meta['en']} (${meta['zh']}). Break at stack $total from the right.',
                  style: GoogleFonts.sourceSerif4(fontSize: 14, height: 1.5, color: theme.inkSoft),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _WallView(
            variant: WallVariant.breakWall,
            theme: theme,
            breakSeat: breakSeat,
            breakStack: breakStackFromRight,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakRule(AppTheme theme, {required String title, required String desc, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.sourceSerif4(
          fontSize: 16, fontWeight: FontWeight.w600, color: theme.ink,
        )),
        const SizedBox(height: 6),
        Text(desc, style: GoogleFonts.sourceSerif4(
          fontSize: 14, height: 1.5, color: theme.inkSoft,
        )),
        if (child is! SizedBox) ...[const SizedBox(height: 10), child],
      ],
    );
  }

  Widget _buildStep3(AppTheme theme, bool isTaiwan) {
    return _StepCard(
      num: '3',
      title: isTaiwan ? 'Deal 16 to each player' : 'Deal 13 to each player',
      desc: isTaiwan
        ? 'Four tiles at a time until everyone has 16. The dealer draws first to hold 17. Any flower or season tile drawn during the deal is immediately revealed, set aside, and replaced from the dead wall.'
        : 'Starting with the dealer, players take tiles in counter-clockwise order (East → South → West → North). Four tiles at a time until everyone has 12, then one more each. The dealer takes 14.',
      theme: theme,
      child: _WallView(variant: WallVariant.deal, theme: theme),
    );
  }

  Widget _buildStep4(AppTheme theme, bool isTaiwan) {
    return _StepCard(
      num: '4',
      title: 'Draw on your turn',
      desc: isTaiwan
        ? 'Click a stack in the wall to draw the next tile. You now have 17 — discard one to return to 16. Play continues counter-clockwise (E → S → W → N).'
        : 'Click a stack in the wall to draw the next tile. You now have 14 — discard one to return to 13. Play continues counter-clockwise (E → S → W → N).',
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    drawing ? 'Drawing…' : hand.length >= maxHand ? 'Hand full' : 'Draw tile',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500,
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
                    border: Border.all(color: theme.rule), borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Reset', style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: hand.isEmpty ? theme.inkMuted : theme.inkSoft,
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _WallView(
            variant: WallVariant.interactive,
            theme: theme,
            drawnCount: hand.length,
            onStackTap: doDraw,
          ),
        ],
      ),
    );
  }

  Widget _buildHand(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper, border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Your hand', style: GoogleFonts.sourceSerif4(
                fontSize: 18, fontWeight: FontWeight.w500, color: theme.ink,
              )),
              const SizedBox(width: 8),
              Text('${hand.length} / $maxHand', style: GoogleFonts.ibmPlexMono(
                fontSize: 13, color: theme.inkMuted,
              )),
              if (hand.length == maxHand)
                Text(' — Hand complete!', style: GoogleFonts.inter(
                  fontSize: 13, color: theme.jade, fontWeight: FontWeight.w500,
                )),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4, runSpacing: 4,
            children: hand.map((tileId) => TileWidget(id: tileId, size: TileSize.sm)).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Step Card ──

class _StepCard extends StatelessWidget {
  final String num;
  final String title;
  final String desc;
  final AppTheme theme;
  final Widget child;

  const _StepCard({
    required this.num, required this.title, required this.desc,
    required this.theme, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.paper, border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28, height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.jade, borderRadius: BorderRadius.circular(999),
                ),
                child: Text(num, style: GoogleFonts.ibmPlexMono(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.sourceSerif4(
                      fontSize: 22, fontWeight: FontWeight.w500, color: theme.ink,
                    )),
                    const SizedBox(height: 6),
                    Text(desc, style: GoogleFonts.sourceSerif4(
                      fontSize: 15, height: 1.55, color: theme.inkSoft,
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ── Wall View ──

enum WallVariant { build, breakWall, deal, interactive }

class _WallView extends StatelessWidget {
  final WallVariant variant;
  final AppTheme theme;
  final String? breakSeat;
  final int? breakStack;
  final int? drawnCount;
  final VoidCallback? onStackTap;

  const _WallView({
    required this.variant, required this.theme,
    this.breakSeat, this.breakStack, this.drawnCount, this.onStackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: theme.wallFelt,
          border: Border.all(color: theme.wallFeltEdge),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(32),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            final sideLen = size - 64;
            final stackSize = sideLen / 19;
            final tileW = stackSize * 0.9;
            final tileH = tileW * 1.3;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Top side (North)
                Positioned(
                  top: 0,
                  child: _buildSide(
                    count: 17, stackSize: stackSize, tileW: tileW, tileH: tileH,
                    axis: Axis.horizontal, side: 'north',
                  ),
                ),
                // Right side (East)
                Positioned(
                  right: 0,
                  child: _buildSide(
                    count: 17, stackSize: stackSize, tileW: tileW, tileH: tileH,
                    axis: Axis.vertical, side: 'east',
                  ),
                ),
                // Bottom side (South)
                Positioned(
                  bottom: 0,
                  child: _buildSide(
                    count: 17, stackSize: stackSize, tileW: tileW, tileH: tileH,
                    axis: Axis.horizontal, side: 'south',
                  ),
                ),
                // Left side (West)
                Positioned(
                  left: 0,
                  child: _buildSide(
                    count: 17, stackSize: stackSize, tileW: tileW, tileH: tileH,
                    axis: Axis.vertical, side: 'west',
                  ),
                ),
                // Center (empty)
                Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSide({
    required int count,
    required double stackSize,
    required double tileW,
    required double tileH,
    required Axis axis,
    required String side,
  }) {
    final sideToSeat = {'top': 'north', 'right': 'east', 'bottom': 'south', 'left': 'west'};
    final currentSeat = sideToSeat[side] ?? side;

    bool isBreakSide = false;
    int breakIndex = -1;
    if (variant == WallVariant.breakWall && breakSeat != null && breakStack != null) {
      isBreakSide = currentSeat == breakSeat;
      breakIndex = count - breakStack!; // from right end
    }

    int drawnFromSide = 0;
    if (variant == WallVariant.interactive && drawnCount != null) {
      drawnFromSide = drawnCount!;
    }

    final List<Widget> stacks = List.generate(count, (i) {
      final fromRight = count - 1 - i;
      final isBroken = isBreakSide && i == breakIndex;
      final isDead = isBreakSide && i > breakIndex;
      final isDrawn = variant == WallVariant.interactive && side == 'top' && fromRight < drawnFromSide;

      Color tileColor = theme.wallTile;
      Color edgeColor = theme.wallTileEdge;
      if (isBroken) {
        tileColor = theme.vermillion;
        edgeColor = theme.vermillionDeep;
      } else if (isDead) {
        tileColor = theme.wallTileDim;
        edgeColor = theme.wallTileDimEdge;
      } else if (isDrawn) {
        tileColor = theme.wallTileDim;
        edgeColor = theme.wallTileDimEdge;
      }

      final stack = GestureDetector(
        onTap: (variant == WallVariant.interactive && side == 'top' && !isDrawn) ? onStackTap : null,
        child: Container(
          width: axis == Axis.horizontal ? stackSize : tileW + 4,
          height: axis == Axis.vertical ? stackSize : tileH * 2 + 6,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _miniTile(tileW, tileH, tileColor, edgeColor),
              const SizedBox(height: 2),
              _miniTile(tileW, tileH, tileColor, edgeColor),
            ],
          ),
        ),
      );

      if (isBroken) {
        return Stack(
          alignment: Alignment.center,
          children: [
            stack,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: theme.vermillion, borderRadius: BorderRadius.circular(2),
              ),
              child: Text('BREAK', style: GoogleFonts.ibmPlexMono(
                fontSize: 7, fontWeight: FontWeight.w600, color: Colors.white,
              )),
            ),
          ],
        );
      }
      return stack;
    });

    final dirLabels = {
      'north': '北 N', 'south': '南 S', 'east': '東 E', 'west': '西 W',
    };

    Widget sideWidget;
    if (axis == Axis.horizontal) {
      sideWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: stacks,
      );
    } else {
      sideWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: stacks,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        sideWidget,
        if (variant != WallVariant.build)
          Positioned(
            top: side == 'north' ? -20 : null,
            bottom: side == 'south' ? -20 : null,
            left: side == 'west' ? -24 : null,
            right: side == 'east' ? -24 : null,
            child: _dirArrow(dirLabels[currentSeat]!, theme, side),
          ),
      ],
    );
  }

  Widget _miniTile(double w, double h, Color color, Color edge) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: edge, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _dirArrow(String text, AppTheme theme, String side) {
    String arrow = '';
    switch (side) {
      case 'north': arrow = '←'; break;
      case 'south': arrow = '→'; break;
      case 'east': arrow = '↑'; break;
      case 'west': arrow = '↓'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: theme.wallArrow, borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (side == 'west' || side == 'south')
            Text(arrow, style: GoogleFonts.ibmPlexMono(fontSize: 10, color: theme.wallArrowGlyph)),
          Text(text, style: GoogleFonts.ibmPlexMono(
            fontSize: 9, fontWeight: FontWeight.w500, color: theme.wallArrowGlyph,
          )),
          if (side == 'north' || side == 'east')
            Text(arrow, style: GoogleFonts.ibmPlexMono(fontSize: 10, color: theme.wallArrowGlyph)),
        ],
      ),
    );
  }
}
