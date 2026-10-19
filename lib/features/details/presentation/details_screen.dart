import 'package:flutter/material.dart';

import '../../../core/widgets/poster_placeholder.dart';
import '../../../features/library/data/mock_library.dart';
import '../../../features/library/domain/media_item.dart';
import '../../../features/library/domain/media_type.dart';
import '../../../features/library/domain/watch_status_label.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.item,
  });

  final MediaItem item;

  static Route<void> route(MediaItem item) {
    return MaterialPageRoute<void>(
      builder: (_) => DetailsScreen(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entry = libraryEntryFor(item.id);
    final typeLabel = switch (item.type) {
      MediaType.movie => 'Movie',
      MediaType.series => 'Series',
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            title: Text(item.title),
            flexibleSpace: FlexibleSpaceBar(
              background: PosterPlaceholder(item: item),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (item.year != null) Chip(label: Text('${item.year}')),
                      Chip(label: Text(typeLabel)),
                      if (item.voteAverage != null)
                        Chip(
                          avatar: Icon(
                            Icons.star_rounded,
                            color: colorScheme.tertiary,
                          ),
                          label: Text(item.voteAverage!.toStringAsFixed(1)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Overview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.overview ?? 'No overview available.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your activity',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: entry == null
                          ? Text(
                              'Not in your library yet',
                              style: theme.textTheme.bodyLarge,
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Chip(label: Text(entry.status.label)),
                                if (entry.userRating != null)
                                  Chip(
                                    avatar: Icon(
                                      Icons.star_rounded,
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                                    backgroundColor:
                                        colorScheme.tertiaryContainer,
                                    label: Text(
                                      entry.userRating!.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: colorScheme.onTertiaryContainer,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
