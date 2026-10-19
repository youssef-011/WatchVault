import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/widgets/load_state_view.dart';
import '../../../core/widgets/poster_image.dart';
import '../../library/application/library_controller.dart';
import '../../library/application/library_scope.dart';
import '../../library/domain/library_entry.dart';
import '../../library/domain/media_item.dart';
import '../../library/domain/media_type.dart';
import '../../library/domain/watch_status.dart';
import '../../library/domain/watch_status_label.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final controller = LibraryScope.of(context);
    return LoadStateView(
      controller: controller,
      childBuilder: (context) {
        final entry = controller.entryFor(item.id);
        return _buildDetails(context, controller, entry);
      },
    );
  }

  Widget _buildDetails(
    BuildContext context,
    LibraryController controller,
    LibraryEntry? entry,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expandedHeight =
        (MediaQuery.sizeOf(context).height * 0.45).clamp(240.0, 360.0).toDouble();
    final typeLabel = switch (item.type) {
      MediaType.movie => 'Movie',
      MediaType.series => 'Series',
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            title: Text(item.title),
            flexibleSpace: FlexibleSpaceBar(
              background: PosterImage(item: item),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (item.voteAverage != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          avatar: Icon(
                            Icons.star_rounded,
                            color: colorScheme.tertiary,
                          ),
                          label: Text(item.voteAverage!.toStringAsFixed(1)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (item.year != null) Chip(label: Text('${item.year}')),
                      Chip(label: Text(typeLabel)),
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
                  if (entry == null)
                    ElevatedButton.icon(
                      onPressed: () => _runMutation(
                        context,
                        controller,
                        () => controller.addExistingMedia(item.id),
                      ),
                      icon: const Icon(Icons.bookmark_add_outlined),
                      label: const Text('Add to Library'),
                    )
                  else ...[
                    const SizedBox(height: 12),
                    SegmentedButton<WatchStatus>(
                      segments: const [
                        ButtonSegment(
                          value: WatchStatus.wantToWatch,
                          label: Text('Want'),
                        ),
                        ButtonSegment(
                          value: WatchStatus.watching,
                          label: Text('Watching'),
                        ),
                        ButtonSegment(
                          value: WatchStatus.watched,
                          label: Text('Watched'),
                        ),
                      ],
                      selected: {entry.status},
                      onSelectionChanged: (selection) => _runMutation(
                        context,
                        controller,
                        () => controller.setStatus(item.id, selection.first),
                      ),
                    ),
                    if (entry.status == WatchStatus.watched) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Your rating: '
                        '${entry.userRating?.toStringAsFixed(1) ?? '—'}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Slider(
                        min: 0,
                        max: 5,
                        divisions: 9,
                        value: entry.userRating ?? 0,
                        label: entry.userRating?.toStringAsFixed(1) ?? '—',
                        onChanged: (rating) {
                          final halfStepRating = (rating * 2).round() / 2;
                          _runMutation(
                            context,
                            controller,
                            () => controller.setRating(
                              item.id,
                              halfStepRating == 0 ? null : halfStepRating,
                            ),
                          );
                        },
                      ),
                    ],
                    TextButton(
                      onPressed: () => _runMutation(
                        context,
                        controller,
                        () => controller.removeEntry(item.id),
                      ),
                      child: const Text('Remove from library'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _runMutation(
  BuildContext context,
  LibraryController controller,
  Future<void> Function() mutation,
) {
  unawaited(() async {
    await mutation();
    if (!context.mounted || controller.errorMessage == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(controller.errorMessage!)),
    );
  }());
}


