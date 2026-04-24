import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';

enum TileSize { xs, sm, md, lg, xl }

class TileWidget extends StatelessWidget {
  final String id;
  final TileSize size;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  const TileWidget({
    super.key,
    required this.id,
    this.size = TileSize.md,
    this.selected = false,
    this.dimmed = false,
    this.onTap,
    this.onEnter,
    this.onExit,
  });

  double get _width {
    switch (size) {
      case TileSize.xs:
        return 32;
      case TileSize.sm:
        return 44;
      case TileSize.md:
        return 60;
      case TileSize.lg:
        return 78;
      case TileSize.xl:
        return 100;
    }
  }

  double get _height {
    switch (size) {
      case TileSize.xs:
        return 41;
      case TileSize.sm:
        return 56;
      case TileSize.md:
        return 77;
      case TileSize.lg:
        return 100;
      case TileSize.xl:
        return 128;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.byId(globalThemeNotifier.value);

    return MouseRegion(
      onEnter: onEnter != null ? (_) => onEnter!() : null,
      onExit: onExit != null ? (_) => onExit!() : null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: theme.paper,
            borderRadius: BorderRadius.circular(4),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: theme.ink.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: theme.ink.withOpacity(0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: Border.all(
              color: selected ? theme.jade : theme.rule,
              width: selected ? 2 : 1,
            ),
          ),
          transform: selected
              ? (Matrix4.identity()..translate(0.0, -4.0))
              : Matrix4.identity(),
          child: Opacity(
            opacity: dimmed ? 0.35 : 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SvgPicture.asset(
                'assets/tiles/$id.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
