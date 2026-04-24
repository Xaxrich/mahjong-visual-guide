import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/tiles.dart';
import 'tile_widget.dart';

class SectionTiles extends StatefulWidget {
  const SectionTiles({super.key});

  @override
  State<SectionTiles> createState() => _SectionTilesState();
}

class _SectionTilesState extends State<SectionTiles> {
  String? hovered;
  String? selected;
  String suit = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);
    final ruleset = globalRulesetNotifier.value;
    final isTaiwan = ruleset == Ruleset.taiwan;

    final allTiles = <MapEntry<String, TileInfo>>[];
    final groups = suit == 'all' ? tiles.keys.toList() : [suit];
    for (final g in groups) {
      if (!tiles.containsKey(g)) continue;
      for (final t in tiles[g]!) {
        allTiles.add(MapEntry(g, t));
      }
    }

    final allFlowerTiles = isTaiwan
        ? [
            ...flowerTiles['flower']!.map((t) => MapEntry('flower', t)),
            ...flowerTiles['season']!.map((t) => MapEntry('season', t)),
          ]
        : <MapEntry<String, TileInfo>>[];

    final activeId = hovered ?? selected;
    final info = activeId != null ? findTile(activeId, includeFlowers: isTaiwan) : null;

    final suitOptions = [
      _SuitOption(id: 'all', label: 'All 34', count: 34),
      _SuitOption(id: 'wan', label: 'Characters', count: 9),
      _SuitOption(id: 'tiao', label: 'Bamboo', count: 9),
      _SuitOption(id: 'bing', label: 'Dots', count: 9),
      _SuitOption(id: 'wind', label: 'Winds', count: 4),
      _SuitOption(id: 'dragon', label: 'Dragons', count: 3),
      if (isTaiwan) _SuitOption(id: 'flower', label: 'Bonus', count: 8),
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, isTaiwan),
          const SizedBox(height: 60),
          _buildPills(suitOptions, theme),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTileGrid(
                        groups,
                        allTiles,
                        allFlowerTiles,
                        theme,
                        isTaiwan,
                      ),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 300,
                      child: _buildInfoCard(info, theme),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _buildTileGrid(groups, allTiles, allFlowerTiles, theme, isTaiwan),
                  const SizedBox(height: 32),
                  _buildInfoCard(info, theme),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme, bool isTaiwan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section 01 · The deck',
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'What are the tiles?',
          style: GoogleFonts.sourceSerif4(
            fontSize: 56,
            height: 1,
            letterSpacing: -1.5,
            fontWeight: FontWeight.w500,
            color: theme.ink,
          ),
        ),
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            style: GoogleFonts.sourceSerif4(
              fontSize: 20,
              height: 1.55,
              color: theme.inkSoft,
            ),
            children: [
              if (isTaiwan)
                const TextSpan(
                  text: 'A mahjong set in Taiwan rules has ',
                )
              else
                const TextSpan(
                  text: 'A mahjong set has ',
                ),
              TextSpan(
                text: isTaiwan ? '144 tiles' : '136 tiles',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
              ),
              if (isTaiwan)
                const TextSpan(
                  text: ': the same 34 unique designs × 4, plus 8 bonus tiles — four Flowers and four Seasons. These are never part of a winning hand; they score separately.',
                )
              else
                const TextSpan(
                  text: ': 34 unique designs, four of each. Three suits run 1–9 (Characters, Bamboo, Dots), plus the honor tiles — four Winds and three Dragons.',
                ),
              const TextSpan(text: ' Hover or tap any tile to learn its name.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPills(List<_SuitOption> options, AppTheme theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: options.map((opt) {
        final isActive = suit == opt.id;
        return InkWell(
          onTap: () {
            setState(() {
              suit = opt.id;
              selected = null;
            });
          },
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  opt.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : theme.inkSoft,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.15)
                        : theme.bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${opt.count}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      color: isActive
                          ? Colors.white.withOpacity(0.9)
                          : theme.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTileGrid(
    List<String> groups,
    List<MapEntry<String, TileInfo>> allTiles,
    List<MapEntry<String, TileInfo>> allFlowerTiles,
    AppTheme theme,
    bool isTaiwan,
  ) {
    return Column(
      children: [
        if (suit != 'flower')
          ...groups.map((g) {
            final meta = suitMeta[g];
            final groupTiles = tiles[g]!;
            return _buildSuitRow(meta!, groupTiles, theme);
          }),
        if (suit == 'flower' || (suit == 'all' && isTaiwan))
          ...flowerTiles.keys.map((g) {
            final meta = flowerMeta[g]!;
            final groupTiles = flowerTiles[g]!;
            return _buildSuitRow(meta, groupTiles, theme, isFlower: true);
          }),
      ],
    );
  }

  Widget _buildSuitRow(SuitMeta meta, List<TileInfo> groupTiles, AppTheme theme,
      {bool isFlower = false}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 32),
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.ruleSoft),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: theme.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta.sub,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 18,
                    color: theme.vermillion,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  meta.desc,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.inkMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isFlower
                      ? '4 tiles · each 1 of a kind'
                      : '${groupTiles.length} tiles · 4 of each',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    color: theme.inkFaint,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: groupTiles.map((t) {
                return TileWidget(
                  id: t.id,
                  size: TileSize.md,
                  selected: selected == t.id,
                  dimmed: false,
                  onTap: () {
                    setState(() {
                      selected = selected == t.id ? null : t.id;
                    });
                  },
                  onEnter: () {
                    setState(() {
                      hovered = t.id;
                    });
                  },
                  onExit: () {
                    setState(() {
                      hovered = null;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(TileInfo? info, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border.all(color: theme.rule),
        borderRadius: BorderRadius.circular(8),
      ),
      child: info != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TileWidget(id: info.id, size: TileSize.lg),
                const SizedBox(height: 20),
                Text(
                  info.zh,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: theme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info.en,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 18,
                    color: theme.inkSoft,
                  ),
                ),
                if (info.num != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Number ${info.num}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: theme.inkMuted,
                    ),
                  ),
                ],
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 48,
                  color: theme.inkFaint,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hover or tap a tile to see its name and meaning.',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 16,
                    color: theme.inkMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SuitOption {
  final String id;
  final String label;
  final int count;

  _SuitOption({required this.id, required this.label, required this.count});
}
