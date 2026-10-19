import 'package:flutter/material.dart';

import '../../features/library/domain/media_item.dart';
import '../../features/library/domain/media_type.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final MediaItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final posterColors = _posterColors(colorScheme, item.id);
    final titleInitial = item.title.trim().isEmpty
        ? '?'
        : item.title.trim().substring(0, 1).toUpperCase();

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Material(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: posterColors,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          titleInitial,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
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
                    if (item.voteAverage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 15,
                                  color: colorScheme.tertiary,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  item.voteAverage!.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 3),
          Text(
            '${item.year ?? '—'} · ${item.type.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  List<Color> _posterColors(ColorScheme colorScheme, int id) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    final first = id.abs() % colors.length;
    final second = (first + 1 + (id.abs() ~/ colors.length) % 2) % colors.length;
    return [colors[first], colors[second]];
  }
}

