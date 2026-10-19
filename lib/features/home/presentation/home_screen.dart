import 'package:flutter/material.dart';

import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../details/presentation/details_screen.dart';
import '../../library/domain/media_item.dart';
import '../data/mock_media.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        _MediaSection(title: 'Trending', items: trending),
        _MediaSection(title: 'Popular Series', items: popularSeries),
        _MediaSection(title: 'Top Rated', items: topRated),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<MediaItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          SizedBox(
            height: 292,
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


