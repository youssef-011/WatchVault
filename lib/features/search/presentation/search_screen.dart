import 'package:flutter/material.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/application/catalog_scope.dart';
import 'package:watchvault/features/search/application/search_results_controller.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/router/details_route_arguments.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../../library/application/library_scope.dart';
import '../../library/domain/watch_status.dart';
import '../../library/domain/watch_status_label.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  late final SearchResultsController _resultsController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _resultsController = SearchResultsController(
      catalog: CatalogScope.of(context),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextField(
                controller: _textController,
                onChanged: (query) {
                  setState(() {});
                  _resultsController.setQuery(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search movies and series',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffixIcon: _textController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _textController.clear();
                            _resultsController.setQuery('');
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _resultsController,
                builder: (context, _) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildResults(),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildResults() {
    switch (_resultsController.status) {
      case SearchResultsStatus.idle:
        return const KeyedSubtree(
          key: ValueKey('search-prompt'),
          child: EmptyState(
            icon: Icons.search,
            title: 'Find something to watch',
            subtitle: 'Search by movie or series title.',
          ),
        );
      case SearchResultsStatus.loading:
        return const Center(
          key: ValueKey('search-loading'),
          child: CircularProgressIndicator(),
        );
      case SearchResultsStatus.error:
        return Center(
          key: const ValueKey('search-error'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyState(
                icon: Icons.error_outline,
                title: 'Something went wrong',
                subtitle: _resultsController.errorMessage ??
                    'Something went wrong. Try again.',
              ),
              FilledButton(
                onPressed: _resultsController.retry,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case SearchResultsStatus.ready:
        final results = _resultsController.results;
        if (results.isEmpty) {
          return KeyedSubtree(
            key: const ValueKey('search-no-results'),
            child: EmptyState(
              icon: Icons.search_off,
              title: 'No results for “${_resultsController.query}”',
              subtitle: 'Try another movie or series title.',
            ),
          );
        }
        return KeyedSubtree(
          key: const ValueKey('search-results'),
          child: LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                mediaCardGridPadding,
                0,
                mediaCardGridPadding,
                AppSpacing.xl,
              ),
              gridDelegate: mediaCardGridDelegate(context, constraints.maxWidth),
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  _resultCard(context, results[index]),
            ),
          ),
        );
    }
  }

  Widget _resultCard(BuildContext context, MediaItem item) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final heroTag = 'search-${item.key.value}';
          final library = LibraryScope.of(context);
          return ListenableBuilder(
            listenable: library,
            builder: (context, _) {
              final status = library.entryFor(item.key)?.status;
              return MediaCard(
                item: item,
                heroTag: heroTag,
                width: constraints.maxWidth,
                libraryStatusLabel: status?.label,
                libraryStatusIcon: _statusIcon(status),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.details,
                  arguments:
                      DetailsRouteArguments(item: item, heroTag: heroTag),
                ),
              );
            },
          );
        },
      );

IconData? _statusIcon(WatchStatus? status) => switch (status) {
      WatchStatus.wantToWatch => Icons.bookmark_border,
      WatchStatus.watching => Icons.play_circle_outline,
      WatchStatus.watched => Icons.check_circle_outline,
      null => null,
    };
}
