import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/data/tmdb_client.dart';

void main() {
  for (final testCase in <(int, CatalogFailure)>[
    (401, CatalogFailure.unauthorized),
    (404, CatalogFailure.notFound),
    (429, CatalogFailure.rateLimited),
    (500, CatalogFailure.server),
  ]) {
    test('maps HTTP ${testCase.$1} to ${testCase.$2.name}', () async {
      final client = TmdbClient(
        client: MockClient((_) async => http.Response('', testCase.$1)),
        token: 'fake-token',
      );

      await expectLater(
        client.getJson('/movie/1'),
        throwsA(
          isA<CatalogException>().having(
            (error) => error.failure,
            'failure',
            testCase.$2,
          ),
        ),
      );
    });
  }

  test('malformed JSON becomes a parse error', () async {
    final client = TmdbClient(
      client: MockClient((_) async => http.Response('{invalid', 200)),
      token: 'fake-token',
    );

    await expectLater(
      client.getJson('/movie/1'),
      throwsA(
        isA<CatalogException>().having(
          (error) => error.failure,
          'failure',
          CatalogFailure.parse,
        ),
      ),
    );
  });

  test('timeout and ClientException become network errors', () async {
    final timedClient = TmdbClient(
      client: MockClient(
        (_) => Future<http.Response>.delayed(
          const Duration(milliseconds: 20),
          () => http.Response('{}', 200),
        ),
      ),
      token: 'fake-token',
      timeout: const Duration(milliseconds: 1),
    );
    final exceptionClient = TmdbClient(
      client: MockClient((_) => throw http.ClientException('offline')),
      token: 'fake-token',
    );

    for (final client in [timedClient, exceptionClient]) {
      await expectLater(
        client.getJson('/movie/1'),
        throwsA(
          isA<CatalogException>().having(
            (error) => error.failure,
            'failure',
            CatalogFailure.network,
          ),
        ),
      );
    }
  });

  test('missing token fails before making a request', () async {
    var requested = false;
    for (final token in ['', 'PASTE_YOUR_TOKEN_HERE']) {
      final client = TmdbClient(
        client: MockClient((_) async {
          requested = true;
          return http.Response('{}', 200);
        }),
        token: token,
      );

      await expectLater(
        client.getJson('/movie/1'),
        throwsA(
          isA<CatalogException>().having(
            (error) => error.failure,
            'failure',
            CatalogFailure.unauthorized,
          ),
        ),
      );
    }
    expect(requested, isFalse);
  });

  test('sends Bearer token and default language query', () async {
    late http.Request received;
    final client = TmdbClient(
      client: MockClient((request) async {
        received = request;
        return http.Response('{}', 200);
      }),
      token: 'fake-token',
    );

    await client.getJson('/movie/1');

    expect(received.url.path, '/3/movie/1');
    expect(received.url.queryParameters['language'], 'en-US');
    expect(
      received.headers.entries
          .singleWhere((entry) => entry.key.toLowerCase() == 'authorization')
          .value,
      'Bearer fake-token',
    );
  });
}
