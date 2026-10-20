import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/catalog/data/tmdb_catalog_repository.dart';
import 'package:watchvault/features/catalog/data/tmdb_client.dart';

void main() {
  test('maps movie and series data, including absent optional fields', () async {
    final client = TmdbClient(
      client: MockClient((request) async {
        if (request.url.path.endsWith('/movie/popular')) {
          return http.Response(
            jsonEncode({
              'results': [
                {
                  'id': 550,
                  'title': 'Fight Club',
                  'poster_path': null,
                  'overview': '',
                  'vote_average': 0,
                },
              ],
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'results': [
              {
                'id': 1399,
                'name': 'Game of Thrones',
                'first_air_date': '2011-04-17',
                'poster_path': '/poster.jpg',
                'overview': 'A fantasy drama.',
                'vote_average': 8.4,
              },
            ],
          }),
          200,
        );
      }),
      token: 'fake-token',
    );
    final repository = TmdbCatalogRepository(client: client);

    final movies = await repository.popularMovies();
    final series = await repository.popularSeries();

    expect(movies.single.key, const MediaKey(type: MediaType.movie, id: 550));
    expect(movies.single.year, isNull);
    expect(movies.single.posterPath, isNull);
    expect(movies.single.overview, isNull);
    expect(movies.single.voteAverage, isNull);
    expect(series.single.key, const MediaKey(type: MediaType.series, id: 1399));
    expect(series.single.year, 2011);
    expect(series.single.voteAverage, 8.4);
  });

  test('search drops people and results without a movie or TV title', () async {
    final client = TmdbClient(
      client: MockClient((_) async => http.Response(
            jsonEncode({
              'results': [
                {'id': 1, 'media_type': 'person', 'name': 'Actor'},
                {'id': 2, 'media_type': 'movie'},
                {'id': 3, 'media_type': 'movie', 'title': 'Movie'},
                {'id': 4, 'media_type': 'tv', 'name': 'Series'},
              ],
            }),
            200,
          )),
      token: 'fake-token',
    );
    final repository = TmdbCatalogRepository(client: client);

    final results = await repository.search('film');

    expect(results.map((item) => item.title), ['Movie', 'Series']);
    expect(results.map((item) => item.type), [MediaType.movie, MediaType.series]);
  });

  test('maps details by movie or TV media key', () async {
    final client = TmdbClient(
      client: MockClient((request) async {
        if (request.url.path.endsWith('/tv/42')) {
          return http.Response(
            jsonEncode({
              'id': 42,
              'name': 'Series',
              'first_air_date': '2024-01-01',
              'tagline': 'TV tagline',
              'genres': [{'name': 'Drama'}],
              'number_of_seasons': 3,
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'id': 42,
            'title': 'Movie',
            'release_date': '2024-01-01',
            'runtime': 110,
          }),
          200,
        );
      }),
      token: 'fake-token',
    );
    final repository = TmdbCatalogRepository(client: client);

    final movie = await repository.details(
      const MediaKey(type: MediaType.movie, id: 42),
    );
    final series = await repository.details(
      const MediaKey(type: MediaType.series, id: 42),
    );

    expect(movie.item.type, MediaType.movie);
    expect(movie.runtimeMinutes, 110);
    expect(series.item.type, MediaType.series);
    expect(series.tagline, 'TV tagline');
    expect(series.genres, ['Drama']);
    expect(series.seasons, 3);
  });
}
