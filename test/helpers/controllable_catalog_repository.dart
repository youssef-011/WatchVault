import 'dart:async';

import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/data/fake_catalog_repository.dart';
import 'package:watchvault/features/catalog/domain/media_details.dart';

class ControllableCatalogRepository extends FakeCatalogRepository {
  final Set<String> failures = {};
  final List<String> searchQueries = [];
  final Map<String, Completer<List<MediaItem>>> pendingSearches = {};
  Duration delay = Duration.zero;

  Future<T> _run<T>(String operation, Future<T> Function() fallback) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failures.contains(operation)) {
      throw const CatalogException.network();
    }
    return fallback();
  }

  @override
  Future<List<MediaItem>> trending() =>
      _run('trending', () => super.trending());

  @override
  Future<List<MediaItem>> popularMovies() =>
      _run('popularMovies', () => super.popularMovies());

  @override
  Future<List<MediaItem>> popularSeries() =>
      _run('popularSeries', () => super.popularSeries());

  @override
  Future<List<MediaItem>> topRatedMovies() =>
      _run('topRatedMovies', () => super.topRatedMovies());

  @override
  Future<List<MediaItem>> topRatedSeries() =>
      _run('topRatedSeries', () => super.topRatedSeries());

  @override
  Future<List<MediaItem>> search(String query) {
    searchQueries.add(query);
    final pending = pendingSearches[query];
    if (pending != null) return pending.future;
    return _run('search', () => super.search(query));
  }

  @override
  Future<MediaDetails> details(MediaKey key) =>
      _run('details', () => super.details(key));
}
