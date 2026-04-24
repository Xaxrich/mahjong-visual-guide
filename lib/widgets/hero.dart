import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.fromLTRB(40, 80, 40, 72),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 11,
                  child: _buildTextContent(theme),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 10,
                  child: _buildAsciiArt(theme),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextContent(theme),
              const SizedBox(height: 40),
              _buildAsciiArt(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextContent(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mahjong Guide',
          style: GoogleFonts.inter(
            fontSize: 13,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            color: theme.vermillion,
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: GoogleFonts.sourceSerif4(
              fontSize: 64,
              height: 0.95,
              letterSpacing: -2,
              fontWeight: FontWeight.w500,
              color: theme.ink,
            ),
            children: [
              const TextSpan(text: 'Mahjong: a '),
              TextSpan(
                text: 'Visual',
                style: GoogleFonts.sourceSerif4(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: theme.jade,
                ),
              ),
              const TextSpan(text: ' Guide'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Learn mahjong in five minutes. A visual guide for total beginners — tiles, winning hands, wall mechanics, and turn actions.',
          style: GoogleFonts.sourceSerif4(
            fontSize: 20,
            height: 1.55,
            color: theme.inkSoft,
          ),
        ),
        const SizedBox(height: 32),
        _buildMeta(theme),
      ],
    );
  }

  Widget _buildMeta(AppTheme theme) {
    return Row(
      children: [
        _MetaItem(
          value: '136',
          label: 'Tiles',
          theme: theme,
        ),
        const SizedBox(width: 40),
        _MetaItem(
          value: '4',
          label: 'Players',
          theme: theme,
        ),
        const SizedBox(width: 40),
        _MetaItem(
          value: '5 min',
          label: 'To learn',
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildAsciiArt(AppTheme theme) {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        _asciiTile,
        style: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          height: 1,
          letterSpacing: 0,
          color: theme.vermillion,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String value;
  final String label;
  final AppTheme theme;

  const _MetaItem({
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.sourceSerif4(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: theme.ink,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: theme.inkMuted,
          ),
        ),
      ],
    );
  }
}

const String _asciiTile = r'''
                          ████████████████
                        ██                ██
                      ██    ████████████    ██
                    ██    ██            ██    ██
                  ██    ██    ████████    ██    ██
                  ██  ██    ██        ██    ██  ██
                  ██  ██  ██    ████    ██  ██  ██
                  ██  ██  ██  ██    ██  ██  ██  ██
                  ██  ██  ██  ██  ██  ██  ██  ██  ██
                  ██  ██  ██  ██    ██  ██  ██  ██
                  ██  ██  ██    ████    ██  ██  ██
                  ██  ██    ██        ██    ██  ██
                  ██    ██    ████████    ██    ██
                  ██    ██                ██    ██
                  ██      ████████████████      ██
                  ██                            ██
                    ████████████████████████████
''';