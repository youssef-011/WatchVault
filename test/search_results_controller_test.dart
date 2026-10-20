import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/search/application/search_results_controller.dart';

import 'helpers/controllable_catalog_repository.dart';

void main() {
  test('debounce fires only the last query and ignores short queries', () async {
    final repository = ControllableCatalogRepository();
    final controller = SearchResultsController(
      catalog: repository,
      debounceDuration: const Duration(milliseconds: 15),
    );
    addTearDown(controller.dispose);

    controller.setQuery('d');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repository.searchQueries, isEmpty);
    controller.setQuery('du');
    controller.setQuery('dune');
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(repository.searchQueries, ['dune']);
  });

  test('stale search response cannot replace the latest results', () async {
    final repository = ControllableCatalogRepository();
    final older = Completer<List<MediaItem>>();
    final latest = Completer<List<MediaItem>>();
    repository.pendingSearches['dune'] = older;
    repository.pendingSearches['bear'] = latest;
    final controller = SearchResultsController(
      catalog: repository,
      debounceDuration: Duration.zero,
    );
    addTearDown(controller.dispose);

    controller.setQuery('dune');
    await Future<void>.delayed(Duration.zero);
    controller.setQuery('bear');
    await Future<void>.delayed(Duration.zero);
    latest.complete([
      const MediaItem(id: 901, title: 'Latest result', type: MediaType.movie),
    ]);
    await Future<void>.delayed(Duration.zero);
    older.complete([
      const MediaItem(id: 900, title: 'Old result', type: MediaType.movie),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(controller.results.map((item) => item.title), ['Latest result']);
  });

  test('search errors can be retried', () async {
    final repository = ControllableCatalogRepository()
      ..failures.add('search');
    final controller = SearchResultsController(
      catalog: repository,
      debounceDuration: Duration.zero,
    );
    addTearDown(controller.dispose);

    controller.setQuery('dune');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(controller.status, SearchResultsStatus.error);
    repository.failures.remove('search');
    await controller.retry();
    expect(controller.status, SearchResultsStatus.ready);
    expect(controller.results, isNotEmpty);
  });
}
