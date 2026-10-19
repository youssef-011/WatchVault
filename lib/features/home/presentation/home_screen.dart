import 'package:flutter/material.dart';

import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../../../core/widgets/section_header.dart';
import '../../details/presentation/details_screen.dart';
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
          items: trending,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        _MediaSection(
          title: 'Popular Series',
          items: popularSeries,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        _MediaSection(
          title: 'Top Rated',
          items: topRated,
          cardWidth: cardWidth,
          listHeight: listHeight,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.title,
    required this.items,
    required this.cardWidth,
    required this.listHeight,
  });

  final String title;
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
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == items.length - 1 ? 0 : 12,
                ),
                child: MediaCard(
                  item: items[index],
                  width: cardWidth,
                  onTap: () => Navigator.of(context).push(
                    DetailsScreen.route(items[index]),
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


