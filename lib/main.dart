import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MahjongApp());
}

class MahjongApp extends StatelessWidget {
  const MahjongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeId>(
      valueListenable: globalThemeNotifier,
      builder: (context, themeId, _) {
        final theme = AppTheme.byId(themeId);
        return MaterialApp(
          title: 'Mahjong: a Visual Guide',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: theme.bg,
            textTheme: TextTheme(
              bodyMedium: GoogleFonts.sourceSerif4(color: theme.ink),
              bodyLarge: GoogleFonts.sourceSerif4(color: theme.ink),
              titleLarge: GoogleFonts.sourceSerif4(color: theme.ink),
              titleMedium: GoogleFonts.sourceSerif4(color: theme.ink),
              titleSmall: GoogleFonts.sourceSerif4(color: theme.ink),
              headlineLarge: GoogleFonts.sourceSerif4(color: theme.ink),
              headlineMedium: GoogleFonts.sourceSerif4(color: theme.ink),
              headlineSmall: GoogleFonts.sourceSerif4(color: theme.ink),
            ),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
