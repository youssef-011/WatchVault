import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/router/details_route_arguments.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../../../core/widgets/section_header.dart';
import '../../library/domain/media_item.dart';
import '../data/mock_media.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.sizeOf(context).width * 0.38).clamp(120.0, 180.0).toDouble();
    final listHeight = mediaCardHeight(context, cardWidth);
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(
            'WatchVault',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _MediaSection(
          title: 'Trending',
          tagPrefix: 'trending',
          items: trending,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        _MediaSection(
          title: 'Popular Series',
          tagPrefix: 'popular-series',
          items: popularSeries,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        _MediaSection(
          title: 'Top Rated',
          tagPrefix: 'top-rated',
          items: topRated,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xxl),
        ),
      ],
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.title,
    required this.tagPrefix,
    required this.items,
    required this.cardWidth,
    required this.listHeight,
  });

  final String title;
  final String tagPrefix;
  final List<MediaItem> items;
  final double cardWidth;
  final double listHeight;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          SizedBox(
            height: listHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == items.length - 1 ? 0 : AppSpacing.md,
                ),
                child: MediaCard(
                  item: items[index],
                  heroTag: '$tagPrefix-${items[index].id}',
                  width: cardWidth,
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.details,
                    arguments: DetailsRouteArguments(
                      item: items[index],
                      heroTag: '$tagPrefix-${items[index].id}',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


