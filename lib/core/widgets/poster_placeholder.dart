import 'package:flutter/material.dart';

import '../../features/library/domain/media_item.dart';
import '../../features/library/domain/media_type.dart';

class PosterPlaceholder extends StatelessWidget {
  const PosterPlaceholder({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleInitial = item.title.trim().isEmpty
        ? '?'
        : item.title.trim().substring(0, 1).toUpperCase();
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    final first = item.id.abs() % colors.length;
    final second = (first + 1 + (item.id.abs() ~/ colors.length) % 2) %
        colors.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors[first], colors[second]],
            ),
          ),
          child: Center(
            child: Text(
              titleInitial,
              style: theme.textTheme.displayLarge?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          child: Icon(
            item.type == MediaType.movie
                ? Icons.movie_outlined
                : Icons.tv_outlined,
            color: colorScheme.onPrimary.withValues(alpha: 0.9),
            size: 20,
          ),
        ),
      ],
    );
  }
}
