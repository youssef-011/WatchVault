import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/data/tmdb_client.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/catalog/domain/media_details.dart';

class TmdbCatalogRepository implements CatalogRepository {
  const TmdbCatalogRepository({required this.client});

  final TmdbClient client;

  @override
  Future<List<MediaItem>> trending() => _results('/trending/all/week');

  @override
  Future<List<MediaItem>> popularMovies() =>
      _results('/movie/popular', forcedType: MediaType.movie);

  @override
  Future<List<MediaItem>> popularSeries() =>
      _results('/tv/popular', forcedType: MediaType.series);

  @override
  Future<List<MediaItem>> topRatedMovies() =>
      _results('/movie/top_rated', forcedType: MediaType.movie);

  @override
  Future<List<MediaItem>> topRatedSeries() =>
      _results('/tv/top_rated', forcedType: MediaType.series);

  @override
  Future<List<MediaItem>> search(String query) async {
    final response = await client.getJson(
      '/search/multi',
      queryParameters: {'query': query},
    );
    final results = _resultMaps(response);
    final media = <MediaItem>[];
    for (final result in results) {
      final typeName = result['media_type'];
      if (typeName == 'person') {
        continue;
      }
      final type = switch (typeName) {
        'movie' => MediaType.movie,
        'tv' => MediaType.series,
        _ => null,
      };
      if (type == null || !_hasTitle(result, type)) {
        continue;
      }
      media.add(_mapItem(result, type));
    }
    return List<MediaItem>.unmodifiable(media);
  }

  @override
  Future<MediaDetails> details(MediaKey key) async {
    final endpoint =
        key.type == MediaType.movie ? '/movie/${key.id}' : '/tv/${key.id}';
    final response = await client.getJson(endpoint);
    if (response is! Map) {
      throw const CatalogException.parse();
    }
    final map = Map<String, Object?>.from(response);
    final item = _mapItem(map, key.type);
    final genresRaw = map['genres'];
    final genres = <String>[];
    if (genresRaw is List) {
      for (final genre in genresRaw) {
        if (genre is Map && genre['name'] is String) {
          genres.add(genre['name']! as String);
        }
      }
    }
    final tagline = map['tagline'];
    final runtime = map['runtime'];
    final seasons = map['number_of_seasons'];
    return MediaDetails(
      item: item,
      tagline: tagline is String && tagline.trim().isNotEmpty ? tagline : null,
      genres: List<String>.unmodifiable(genres),
      runtimeMinutes: key.type == MediaType.movie ? _integer(runtime) : null,
      seasons: key.type == MediaType.series ? _integer(seasons) : null,
    );
  }

  Future<List<MediaItem>> _results(
    String endpoint, {
    MediaType? forcedType,
  }) async {
    final response = await client.getJson(endpoint);
    final results = _resultMaps(response);
    final media = <MediaItem>[];
    for (final result in results) {
      final type = forcedType ?? _typeFromResult(result);
      if (type != null && _hasTitle(result, type)) {
        media.add(_mapItem(result, type));
      }
    }
    return List<MediaItem>.unmodifiable(media);
  }

  List<Map<String, Object?>> _resultMaps(Object? response) {
    if (response is! Map || response['results'] is! List) {
      throw const CatalogException.parse();
    }
    try {
      return (response['results']! as List)
          .whereType<Map>()
          .map((value) => Map<String, Object?>.from(value))
          .toList(growable: false);
    } on Object {
      throw const CatalogException.parse();
    }
  }

  MediaType? _typeFromResult(Map<String, Object?> map) =>
      switch (map['media_type']) {
        'movie' => MediaType.movie,
        'tv' => MediaType.series,
        _ => null,
      };

  bool _hasTitle(Map<String, Object?> map, MediaType type) {
    final title = type == MediaType.movie ? map['title'] : map['name'];
    return title is String && title.trim().isNotEmpty;
  }

  MediaItem _mapItem(Map<String, Object?> map, MediaType type) {
    final id = _integer(map['id']);
    final rawTitle = type == MediaType.movie ? map['title'] : map['name'];
    if (id == null || rawTitle is! String || rawTitle.trim().isEmpty) {
      throw const CatalogException.parse();
    }
    final date = type == MediaType.movie
        ? map['release_date']
        : map['first_air_date'];
    final overview = map['overview'];
    final posterPath = map['poster_path'];
    final rating = map['vote_average'];
    return MediaItem(
      id: id,
      title: rawTitle,
      type: type,
      year: _year(date),
      posterPath:
          posterPath is String && posterPath.isNotEmpty ? posterPath : null,
      overview:
          overview is String && overview.trim().isNotEmpty ? overview : null,
      voteAverage: rating is num && rating != 0 ? rating.toDouble() : null,
    );
  }

  int? _integer(Object? value) => value is num ? value.toInt() : null;

  int? _year(Object? value) {
    if (value is! String || value.length < 4) {
      return null;
    }
    return int.tryParse(value.substring(0, 4));
  }
}
