import 'package:flutter/material.dart';

enum AppThemeId { jade, lacquer, study }

enum Ruleset { hk, taiwan }

class AppTheme {
  final String name;
  final String label;
  final Color bg;
  final Color bgAlt;
  final Color paper;
  final Color ink;
  final Color inkSoft;
  final Color inkMuted;
  final Color inkFaint;
  final Color rule;
  final Color ruleSoft;
  final Color jade;
  final Color jadeDeep;
  final Color jadeBright;
  final Color jadeWash;
  final Color vermillion;
  final Color vermillionDeep;
  final Color vermillionWash;
  final Color gold;
  final Color wallFelt;
  final Color wallFeltEdge;
  final Color wallArrow;
  final Color wallArrowGlyph;
  final Color wallTile;
  final Color wallTileEdge;
  final Color wallTileDim;
  final Color wallTileDimEdge;
  final Color wallTileHover;

  const AppTheme({
    required this.name,
    required this.label,
    required this.bg,
    required this.bgAlt,
    required this.paper,
    required this.ink,
    required this.inkSoft,
    required this.inkMuted,
    required this.inkFaint,
    required this.rule,
    required this.ruleSoft,
    required this.jade,
    required this.jadeDeep,
    required this.jadeBright,
    required this.jadeWash,
    required this.vermillion,
    required this.vermillionDeep,
    required this.vermillionWash,
    required this.gold,
    required this.wallFelt,
    required this.wallFeltEdge,
    required this.wallArrow,
    required this.wallArrowGlyph,
    required this.wallTile,
    required this.wallTileEdge,
    required this.wallTileDim,
    required this.wallTileDimEdge,
    required this.wallTileHover,
  });

  static const jadeTheme = AppTheme(
    name: 'jade',
    label: 'Jade',
    bg: Color(0xFFF1EDE0),
    bgAlt: Color(0xFFECE5D0),
    paper: Color(0xFFFAF6E9),
    ink: Color(0xFF1A1A12),
    inkSoft: Color(0xFF3D3A30),
    inkMuted: Color(0xFF7A7565),
    inkFaint: Color(0xFFB0A993),
    rule: Color(0xFFD9CFAE),
    ruleSoft: Color(0xFFE8DFC9),
    jade: Color(0xFF006C00),
    jadeDeep: Color(0xFF003500),
    jadeBright: Color(0xFF1A8A22),
    jadeWash: Color(0x14006C00),
    vermillion: Color(0xFFBA0000),
    vermillionDeep: Color(0xFF9C0000),
    vermillionWash: Color(0x14BA0000),
    gold: Color(0xFFA88536),
    wallFelt: Color(0xFF0A4A1A),
    wallFeltEdge: Color(0xFF003500),
    wallArrow: Color(0xFFF5E19A),
    wallArrowGlyph: Color(0xFFD4B566),
    wallTile: Color(0xFF1A6A1E),
    wallTileEdge: Color(0xFF003500),
    wallTileDim: Color(0xFF0A3A10),
    wallTileDimEdge: Color(0xFF001A00),
    wallTileHover: Color(0xFF2A8A30),
  );

  static const lacquerTheme = AppTheme(
    name: 'lacquer',
    label: 'Lacquer',
    bg: Color(0xFF0C1A0E),
    bgAlt: Color(0xFF0F2311),
    paper: Color(0xFF123216),
    ink: Color(0xFFF4EED9),
    inkSoft: Color(0xFFD9CEAB),
    inkMuted: Color(0xFF8FA37F),
    inkFaint: Color(0xFF4E6A52),
    rule: Color(0x40A88536),
    ruleSoft: Color(0x1EA88536),
    jade: Color(0xFFB8F0B6),
    jadeDeep: Color(0xFF006C00),
    jadeBright: Color(0xFFB8F0B6),
    jadeWash: Color(0x14B8F0B6),
    vermillion: Color(0xFFFF6B5E),
    vermillionDeep: Color(0xFFC83A2E),
    vermillionWash: Color(0x1AFF6B5E),
    gold: Color(0xFFD4A849),
    wallFelt: Color(0xFF05160A),
    wallFeltEdge: Color(0xFF2A4A2E),
    wallArrow: Color(0xFFF5E19A),
    wallArrowGlyph: Color(0xFFE8C97A),
    wallTile: Color(0xFF1A4D22),
    wallTileEdge: Color(0xFF05160A),
    wallTileDim: Color(0xFF0A2A12),
    wallTileDimEdge: Color(0xFF03100A),
    wallTileHover: Color(0xFF2E7036),
  );

  static const studyTheme = AppTheme(
    name: 'study',
    label: 'Study',
    bg: Color(0xFFFFF8E8),
    bgAlt: Color(0xFFFFEDC4),
    paper: Color(0xFFFFFFFF),
    ink: Color(0xFF1A1810),
    inkSoft: Color(0xFF3D3A2A),
    inkMuted: Color(0xFF6F6A52),
    inkFaint: Color(0xFFB0A080),
    rule: Color(0xFFF0D8A0),
    ruleSoft: Color(0xFFF7E8C4),
    jade: Color(0xFF006C00),
    jadeDeep: Color(0xFF003500),
    jadeBright: Color(0xFF1A8A22),
    jadeWash: Color(0x14006C00),
    vermillion: Color(0xFFBA0000),
    vermillionDeep: Color(0xFF9C0000),
    vermillionWash: Color(0x14BA0000),
    gold: Color(0xFFD89B2A),
    wallFelt: Color(0xFFE9D9A3),
    wallFeltEdge: Color(0xFFC9B376),
    wallArrow: Color(0xFF4A3818),
    wallArrowGlyph: Color(0xFF6B5226),
    wallTile: Color(0xFFF7EBC4),
    wallTileEdge: Color(0xFFB89A52),
    wallTileDim: Color(0xFFE0CF9A),
    wallTileDimEdge: Color(0xFFA88A42),
    wallTileHover: Color(0xFFFFFFFF),
  );

  static AppTheme byId(AppThemeId id) {
    switch (id) {
      case AppThemeId.jade:
        return jadeTheme;
      case AppThemeId.lacquer:
        return lacquerTheme;
      case AppThemeId.study:
        return studyTheme;
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: name == 'lacquer' ? Brightness.dark : Brightness.light,
        primary: jade,
        onPrimary: Colors.white,
        secondary: vermillion,
        onSecondary: Colors.white,
        surface: paper,
        onSurface: ink,
        error: vermillion,
        onError: Colors.white,
      ),
    );
  }
}

class ThemeNotifier extends ValueNotifier<AppThemeId> {
  ThemeNotifier() : super(AppThemeId.jade);

  AppTheme get theme => AppTheme.byId(value);

  void setTheme(AppThemeId id) => value = id;
}

class RulesetNotifier extends ValueNotifier<Ruleset> {
  RulesetNotifier() : super(Ruleset.hk);

  void setRuleset(Ruleset r) => value = r;
}

class ActiveSectionNotifier extends ValueNotifier<String> {
  ActiveSectionNotifier() : super('section-tiles');

  void setActive(String id) => value = id;
}

final globalThemeNotifier = ThemeNotifier();
final globalRulesetNotifier = RulesetNotifier();
final globalActiveSectionNotifier = ActiveSectionNotifier();
