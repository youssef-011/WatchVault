import 'package:flutter/material.dart';

import '../../features/library/domain/media_item.dart';
import '../../features/library/domain/media_type.dart';
import '../theme/app_spacing.dart';
import 'poster_image.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.item,
    required this.heroTag,
    this.onTap,
    this.onLongPress,
    this.userRating,
    this.width = 140,
  });

  final MediaItem item;
  final String heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? userRating;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeLabel = switch (item.type) {
      MediaType.movie => 'Movie',
      MediaType.series => 'Series',
    };

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Material(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(tag: heroTag, child: PosterImage(item: item)),
                    if (item.voteAverage != null)
                      Positioned(
                        top: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: _ratingChip(
                          context,
                          item.voteAverage!,
                          backgroundColor:
                              colorScheme.surface.withValues(alpha: 0.92),
                          foregroundColor: colorScheme.onSurface,
                          starColor: colorScheme.tertiary,
                          semanticsLabel:
                              'Community rating ${item.voteAverage!.toStringAsFixed(1)}',
                        ),
                      ),
                    if (userRating != null)
                      Positioned(
                        bottom: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: _ratingChip(
                          context,
                          userRating!,
                          backgroundColor: colorScheme.tertiaryContainer,
                          foregroundColor: colorScheme.onTertiaryContainer,
                          starColor: colorScheme.onTertiaryContainer,
                          semanticsLabel:
                              'Your rating ${userRating!.toStringAsFixed(1)}',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 5,
          ),
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
      ),
    );
  }
}
