import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/catalog/application/catalog_scope.dart';
import 'package:watchvault/features/details/application/details_controller.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/poster_image.dart';
import '../../library/application/library_controller.dart';
import '../../library/application/library_scope.dart';
import '../../library/domain/library_entry.dart';
import '../../library/domain/watch_status.dart';
import '../../library/domain/watch_status_label.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.item,
    required this.heroTag,
  });

  final MediaItem item;
  final String heroTag;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final DetailsController _detailsController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _detailsController = DetailsController(
      catalog: CatalogScope.of(context),
      item: widget.item,
    );
    unawaited(_detailsController.load());
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryScope.of(context);
    return ListenableBuilder(
      listenable: _detailsController,
      builder: (context, _) => ListenableBuilder(
        listenable: library,
        builder: (context, _) => _buildDetails(context, library),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, LibraryController library) {
    final item = widget.item;
    final details = _detailsController.details;
    final entry = library.entryFor(item.key);
    final isInLocalCatalog = library.mediaByKey(item.key) != null;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expandedHeight =
        (MediaQuery.sizeOf(context).height * 0.45).clamp(240.0, 360.0).toDouble();
    final typeLabel = item.type == MediaType.movie ? 'Movie' : 'Series';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: PosterImage(item: item, size: 'w500'),
                  ),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.48),
                            Colors.transparent,
                          ],
                          stops: const [0, 1],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                        const SizedBox(width: AppSpacing.sm),
                        Chip(
                          avatar: Icon(Icons.star_rounded,
                              color: colorScheme.tertiary),
                          label: Text(item.voteAverage!.toStringAsFixed(1)),
                        ),
                      ],
                    ],
                  ),
                  if (details?.tagline != null) ...[
                    Text(details!.tagline!, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (item.year != null) Chip(label: Text('${item.year}')),
                      Chip(label: Text(typeLabel)),
                      if (details?.runtimeMinutes case final minutes?)
                        Chip(label: Text(_formatRuntime(minutes))),
                      if (details?.seasons case final seasons?)
                        Chip(label: Text('$seasons seasons')),
                      for (final genre in details?.genres ?? <String>[])
                        Chip(label: Text(genre)),
                    ],
                  ),
                  if (_detailsController.status == LoadStatus.error) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _detailsController.errorMessage ??
                                'Something went wrong. Try again.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        TextButton(
                          onPressed: _detailsController.load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ],
                  if (_detailsController.status == LoadStatus.loading &&
                      item.id >= 0)
                    const LinearProgressIndicator(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Overview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(item.overview ?? 'No overview available.',
                      style: theme.textTheme.bodyLarge),
                  if (isInLocalCatalog) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Your activity',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: entry == null
                            ? Text('Not in your library yet',
                                style: theme.textTheme.bodyLarge)
                            : Wrap(
                                spacing: AppSpacing.sm,
                                children: [
                                  Chip(label: Text(entry.status.label)),
                                  if (entry.userRating != null)
                                    Chip(
                                      avatar: Icon(Icons.star_rounded,
                                          color: colorScheme
                                              .onTertiaryContainer),
                                      backgroundColor:
                                          colorScheme.tertiaryContainer,
                                      label: Text(
                                        entry.userRating!.toStringAsFixed(1),
                                        style: TextStyle(
                                          color:
                                              colorScheme.onTertiaryContainer,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                    _libraryControls(context, library, entry),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _libraryControls(
    BuildContext context,
    LibraryController controller,
    LibraryEntry? entry,
  ) =>
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: entry == null
            ? ElevatedButton.icon(
                key: const ValueKey('add-to-library'),
                onPressed: () => _runMutation(
                  context,
                  controller,
                  () => controller.addExistingMedia(widget.item.key),
                ),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Add to Library'),
              )
            : Column(
                key: const ValueKey('library-status-controls'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<WatchStatus>(
                    segments: const [
                      ButtonSegment(
                          value: WatchStatus.wantToWatch, label: Text('Want')),
                      ButtonSegment(
                          value: WatchStatus.watching, label: Text('Watching')),
                      ButtonSegment(
                          value: WatchStatus.watched, label: Text('Watched')),
                    ],
                    selected: {entry.status},
                    onSelectionChanged: (selection) => _runMutation(
                      context,
                      controller,
                      () => controller.setStatus(widget.item.key, selection.first),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: entry.status == WatchStatus.watched
                        ? Column(
                            key: const ValueKey('rating-visible'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Your rating: '
                                '${entry.userRating?.toStringAsFixed(1) ?? '—'}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Slider(
                                min: 0,
                                max: 5,
                                divisions: 9,
                                value: entry.userRating ?? 0,
                                label: entry.userRating?.toStringAsFixed(1) ?? '—',
                                onChanged: (rating) {
                                  final halfStep = (rating * 2).round() / 2;
                                  _runMutation(
                                    context,
                                    controller,
                                    () => controller.setRating(
                                      widget.item.key,
                                      halfStep == 0 ? null : halfStep,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(
                            key: ValueKey('rating-hidden'),
                          ),
                  ),
                  TextButton(
                    onPressed: () => _runMutation(
                      context,
                      controller,
                      () => controller.removeEntry(widget.item.key),
                    ),
                    child: const Text('Remove from library'),
                  ),
                ],
              ),
      );
}

String _formatRuntime(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  if (hours == 0) return '${remainingMinutes}m';
  if (remainingMinutes == 0) return '${hours}h';
  return '${hours}h ${remainingMinutes}m';
}

void _runMutation(
  BuildContext context,
  LibraryController controller,
  Future<void> Function() mutation,
) {
  unawaited(() async {
    await mutation();
    if (!context.mounted || controller.errorMessage == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(controller.errorMessage!)),
    );
  }());
}
