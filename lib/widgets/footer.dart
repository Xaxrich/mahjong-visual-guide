import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.rule),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Mahjong ',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.inkMuted,
                ),
              ),
              Text(
                '麻將',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.vermillion,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'A visual guide for total beginners.',
            style: GoogleFonts.sourceSerif4(
              fontSize: 14,
              color: theme.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
