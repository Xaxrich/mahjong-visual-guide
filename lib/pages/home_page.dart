import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../theme.dart';
import '../data/sections.dart';
import '../widgets/sidenav.dart';
import '../widgets/hero.dart';
import '../widgets/section_tiles.dart';
import '../widgets/section_win.dart';
import '../widgets/section_draw.dart';
import '../widgets/section_actions.dart';
import '../widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _positionsListener.itemPositions.addListener(_onScroll);
  }

  void _onScroll() {
    final positions = _positionsListener.itemPositions.value;
    if (positions.isEmpty) return;
    final visible = positions.where((p) => p.itemLeadingEdge < 0.65 && p.itemTrailingEdge > 0.35);
    if (visible.isEmpty) return;
    final first = visible.reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);
    final index = first.index;
    if (index > 0 && index <= sections.length) {
      globalActiveSectionNotifier.setActive(sections[index - 1].id);
    }
  }

  void _scrollTo(int index) {
    _scrollController.scrollTo(
      index: index + 1, // +1 because hero is at index 0
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeId>(
      valueListenable: globalThemeNotifier,
      builder: (context, themeId, _) {
        final theme = AppTheme.byId(themeId);
        return ValueListenableBuilder<Ruleset>(
          valueListenable: globalRulesetNotifier,
          builder: (context, ruleset, _) {
            return ValueListenableBuilder<String>(
              valueListenable: globalActiveSectionNotifier,
              builder: (context, activeSection, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 1024;
                    return Scaffold(
                      backgroundColor: theme.bg,
                      body: Row(
                        children: [
                          if (isDesktop)
                            SizedBox(
                              width: 280,
                              height: double.infinity,
                              child: Sidenav(
                                activeSection: activeSection,
                                onNavigate: _scrollTo,
                                themeNotifier: globalThemeNotifier,
                                rulesetNotifier: globalRulesetNotifier,
                              ),
                            ),
                          Expanded(
                            child: Column(
                              children: [
                                if (!isDesktop) _MobileTopBar(
                                  activeSection: activeSection,
                                  onNavigate: _scrollTo,
                                  theme: theme,
                                ),
                                Expanded(
                                  child: ScrollablePositionedList.builder(
                                    itemScrollController: _scrollController,
                                    itemPositionsListener: _positionsListener,
                                    itemCount: sections.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return const HeroSection();
                                      }
                                      final section = sections[index - 1];
                                      switch (section.id) {
                                        case 'section-tiles':
                                          return const SectionTiles();
                                        case 'section-win':
                                          return const SectionWin();
                                        case 'section-draw':
                                          return const SectionDraw();
                                        case 'section-actions':
                                          return const SectionActions();
                                        default:
                                          return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                                const Footer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _positionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }
}

class _MobileTopBar extends StatelessWidget {
  final String activeSection;
  final void Function(int) onNavigate;
  final AppTheme theme;

  const _MobileTopBar({
    required this.activeSection,
    required this.onNavigate,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final active = sections.firstWhere(
      (s) => s.id == activeSection,
      orElse: () => sections.first,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.paper,
        border: Border(bottom: BorderSide(color: theme.rule)),
      ),
      child: Row(
        children: [
          Text(
            'Mahjong 麻將',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.ink,
            ),
          ),
          const Spacer(),
          Text(
            '${active.num} ${active.label}',
            style: TextStyle(
              fontSize: 13,
              color: theme.inkMuted,
            ),
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.menu, color: theme.inkSoft),
            onSelected: onNavigate,
            itemBuilder: (context) {
              return sections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;
                return PopupMenuItem(
                  value: index,
                  child: Text('${section.num} ${section.label}'),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}
