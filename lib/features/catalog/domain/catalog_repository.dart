import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/features/catalog/domain/media_details.dart';

abstract interface class CatalogRepository {
  Future<List<MediaItem>> trending();

  Future<List<MediaItem>> popularMovies();

  Future<List<MediaItem>> popularSeries();

  Future<List<MediaItem>> topRatedMovies();

  Future<List<MediaItem>> topRatedSeries();

  Future<List<MediaItem>> search(String query);

  Future<MediaDetails> details(MediaKey key);
}
