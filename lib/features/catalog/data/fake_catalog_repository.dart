import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/catalog/domain/media_details.dart';

import '../../home/data/mock_media.dart';

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository({Iterable<MediaItem> items = mockMedia})
      : _items = List<MediaItem>.unmodifiable(items);

  final List<MediaItem> _items;

  @override
  Future<List<MediaItem>> trending() async => _items.take(6).toList();

  @override
  Future<List<MediaItem>> popularMovies() async => _byType(MediaType.movie);

  @override
  Future<List<MediaItem>> popularSeries() async => _byType(MediaType.series);

  @override
  Future<List<MediaItem>> topRatedMovies() async => _sorted(MediaType.movie);

  @override
  Future<List<MediaItem>> topRatedSeries() async => _sorted(MediaType.series);

  @override
  Future<List<MediaItem>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const [];
    return _items
        .where((item) => item.title.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  @override
  Future<MediaDetails> details(MediaKey key) async {
    for (final item in _items) {
      if (item.key == key) return MediaDetails(item: item);
    }
    throw const CatalogException.notFound();
  }

  List<MediaItem> _byType(MediaType type) =>
      _items.where((item) => item.type == type).take(6).toList();

  List<MediaItem> _sorted(MediaType type) {
    final items = _items.where((item) => item.type == type).toList()
      ..sort((a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0));
    return items.take(6).toList(growable: false);
  }
}
