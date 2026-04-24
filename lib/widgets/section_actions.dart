import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'tile_widget.dart';

class _TurnAction {
  final String id;
  final String name;
  final String zh;
  final String pinyin;
  final String en;
  final String when;
  final String desc;
  final List<String> example;
  final String exampleNote;

  const _TurnAction({
    required this.id,
    required this.name,
    required this.zh,
    required this.pinyin,
    required this.en,
    required this.when,
    required this.desc,
    required this.example,
    required this.exampleNote,
  });
}

const List<_TurnAction> _turnActions = [
  _TurnAction(
    id: 'draw',
    name: 'Draw',
    zh: '摸牌',
    pinyin: 'mō pái',
    en: '"feel for a tile"',
    when: 'Always — it starts your turn',
    desc: 'Take one tile from the wall. Your hand now has 14 tiles.',
    example: ['bing-5'],
    exampleNote: 'one new tile',
  ),
  _TurnAction(
    id: 'discard',
    name: 'Discard',
    zh: '打牌',
    pinyin: 'dǎ pái',
    en: '"strike the tile"',
    when: 'End of your turn',
    desc: 'Throw away one tile face-up. Your hand returns to 13.',
    example: ['wan-1'],
    exampleNote: 'one tile out',
  ),
  _TurnAction(
    id: 'chow',
    name: 'Chow',
    zh: '吃',
    pinyin: 'chī',
    en: '"eat"',
    when: 'Only from the player on your left',
    desc: 'Claim a just-discarded tile to complete a run of three in one suit.',
    example: ['tiao-3', 'tiao-4', 'tiao-5'],
    exampleNote: '3–4–5 bamboo',
  ),
  _TurnAction(
    id: 'pung',
    name: 'Pung',
    zh: '碰',
    pinyin: 'pèng',
    en: '"bump"',
    when: 'From any player',
    desc: 'Claim a discard to complete a triplet. Beats chow.',
    example: ['bing-7', 'bing-7', 'bing-7'],
    exampleNote: 'three 7-dots',
  ),
  _TurnAction(
    id: 'kong',
    name: 'Kong',
    zh: '杠',
    pinyin: 'gàng',
    en: '"bar"',
    when: 'From any discard, or concealed in your hand',
    desc: 'Four of a kind. Draw a replacement tile from the dead wall.',
    example: ['east', 'east', 'east', 'east'],
    exampleNote: 'four East winds',
  ),
  _TurnAction(
    id: 'hu',
    name: 'Hu · Mahjong!',
    zh: '胡',
    pinyin: 'hú',
    en: '"complete"',
    when: 'When your hand would be complete',
    desc: 'Declare win. Ends the hand. Highest priority — beats everyone.',
    example: ['red', 'red'],
    exampleNote: 'final pair lands',
  ),
];

class _SetExample {
  final String kind;
  final String desc;
  final List<_Example> valid;
  final List<_Example> invalid;

  const _SetExample({
    required this.kind,
    required this.desc,
    required this.valid,
    required this.invalid,
  });
}

class _Example {
  final List<String> tiles;
  final String note;

  const _Example({required this.tiles, required this.note});
}

const List<_SetExample> _setExamples = [
  _SetExample(
    kind: 'Chow (chī) · 吃',
    desc: 'Three tiles in a row, same suit.',
    valid: [
      _Example(tiles: ['wan-4', 'wan-5', 'wan-6'], note: 'Clean run in Characters'),
      _Example(tiles: ['tiao-1', 'tiao-2', 'tiao-3'], note: 'Lowest run in Bamboo'),
      _Example(tiles: ['bing-7', 'bing-8', 'bing-9'], note: 'Run including terminal 9'),
    ],
    invalid: [
      _Example(tiles: ['wan-1', 'wan-2', 'tiao-3'], note: 'Mixed suits — not allowed'),
      _Example(tiles: ['bing-2', 'bing-4', 'bing-6'], note: 'Not consecutive'),
      _Example(tiles: ['east', 'south', 'west'], note: 'Honors can never form a chow'),
    ],
  ),
  _SetExample(
    kind: 'Pung (pèng) · 碰',
    desc: 'Three identical tiles.',
    valid: [
      _Example(tiles: ['wan-5', 'wan-5', 'wan-5'], note: 'Triple 5 of Characters'),
      _Example(tiles: ['east', 'east', 'east'], note: 'Triple East Wind'),
      _Example(tiles: ['red', 'red', 'red'], note: 'Triple Red Dragon — scoring!'),
    ],
    invalid: [
      _Example(tiles: ['wan-5', 'wan-5', 'wan-6'], note: 'Only two match — this is a pair + one'),
      _Example(tiles: ['tiao-3', 'bing-3', 'wan-3'], note: 'Same number across suits doesn\'t count'),
      _Example(tiles: ['east', 'south', 'east'], note: 'Two East ≠ three East'),
    ],
  ),
  _SetExample(
    kind: 'Kong (gàng) · 杠',
    desc: 'Four of the same tile. Earns a bonus draw.',
    valid: [
      _Example(tiles: ['tiao-4', 'tiao-4', 'tiao-4', 'tiao-4'], note: 'All four 4-bamboos'),
      _Example(tiles: ['white', 'white', 'white', 'white'], note: 'Concealed kong of White Dragon'),
    ],
    invalid: [
      _Example(tiles: ['bing-2', 'bing-2', 'bing-2', 'bing-3'], note: 'One tile is different'),
      _Example(tiles: ['wan-7', 'wan-7', 'wan-7'], note: 'Only three — this is a pung'),
    ],
  ),
  _SetExample(
    kind: 'Pair · 對 (the "eyes")',
    desc: 'Two identical tiles. Every winning hand has exactly one.',
    valid: [
      _Example(tiles: ['green', 'green'], note: 'Pair of Green Dragons'),
      _Example(tiles: ['bing-5', 'bing-5'], note: 'Any two of the same'),
    ],
    invalid: [
      _Example(tiles: ['bing-5', 'bing-6'], note: 'Different tiles — not a pair'),
      _Example(tiles: ['east', 'west'], note: 'Different winds — not a pair'),
    ],
  ),
];

class SectionActions extends StatelessWidget {
  const SectionActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 60),
          _buildActionList(theme),
          const SizedBox(height: 60),
          _buildExamples(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section 04 · Your turn',
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'What can you do each turn?',
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
          'On your turn you always draw then discard. Between turns, you can interrupt to claim another player\'s discard — if you can use it to complete a set.',
          style: GoogleFonts.sourceSerif4(
            fontSize: 20,
            height: 1.55,
            color: theme.inkSoft,
          ),
        ),
      ],
    );
  }

  Widget _buildActionList(AppTheme theme) {
    return Column(
      children: _turnActions.map((action) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.paper,
            border: Border.all(color: theme.rule),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          action.name,
                          style: GoogleFonts.sourceSerif4(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: theme.ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          action.zh,
                          style: GoogleFonts.sourceSerif4(
                            fontSize: 18,
                            color: theme.vermillion,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${action.pinyin} · ${action.en}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.jadeWash,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        action.when,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.jade,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action.desc,
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 16,
                        height: 1.5,
                        color: theme.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Wrap(
                    spacing: 4,
                    children: action.example.map((tileId) {
                      return TileWidget(id: tileId, size: TileSize.sm);
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.exampleNote,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 10,
                      color: theme.inkFaint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExamples(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set examples',
          style: GoogleFonts.sourceSerif4(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: theme.ink,
          ),
        ),
        const SizedBox(height: 32),
        ..._setExamples.map((ex) {
          return Container(
            margin: const EdgeInsets.only(bottom: 32),
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
                  ex.kind,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: theme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ex.desc,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 16,
                    color: theme.inkSoft,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Valid',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: theme.jade,
                  ),
                ),
                const SizedBox(height: 8),
                ...ex.valid.map((v) => _buildExampleRow(v, theme, true)),
                const SizedBox(height: 16),
                Text(
                  'Invalid',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: theme.vermillion,
                  ),
                ),
                const SizedBox(height: 8),
                ...ex.invalid.map((v) => _buildExampleRow(v, theme, false)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExampleRow(_Example ex, AppTheme theme, bool valid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Wrap(
            spacing: 4,
            children: ex.tiles.map((tileId) {
              return TileWidget(id: tileId, size: TileSize.xs);
            }).toList(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ex.note,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: valid ? theme.inkMuted : theme.vermillion.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
