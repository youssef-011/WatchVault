import 'package:flutter/material.dart';

import '../../features/library/domain/media_item.dart';
import '../../features/library/domain/media_type.dart';
import 'poster_placeholder.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.item,
    this.onTap,
    this.userRating,
  });

  final MediaItem item;
  final VoidCallback? onTap;
  final double? userRating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeLabel = switch (item.type) {
      MediaType.movie => 'Movie',
      MediaType.series => 'Series',
    };

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
                    PosterPlaceholder(item: item),
                    if (item.voteAverage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _ratingChip(
                          context,
                          item.voteAverage!,
                          backgroundColor:
                              colorScheme.surface.withValues(alpha: 0.92),
                          foregroundColor: colorScheme.onSurface,
                          starColor: colorScheme.tertiary,
                        ),
                      ),
                    if (userRating != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: _ratingChip(
                          context,
                          userRating!,
                          backgroundColor: colorScheme.tertiaryContainer,
                          foregroundColor: colorScheme.onTertiaryContainer,
                          starColor: colorScheme.onTertiaryContainer,
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
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 3),
          Text(
            '${item.year?.toString() ?? '—'} · $typeLabel',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingChip(
    BuildContext context,
    double rating, {
    required Color backgroundColor,
    required Color foregroundColor,
    required Color starColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 15, color: starColor),
            const SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

