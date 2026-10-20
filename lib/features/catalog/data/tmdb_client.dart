import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:watchvault/features/catalog/data/catalog_exception.dart';

import '../../../core/config/app_config.dart';

class TmdbClient {
  TmdbClient({
    http.Client? client,
    String? token = AppConfig.tmdbReadToken,
    Uri? baseUri,
    this.timeout = const Duration(seconds: 10),
  })  : _client = client ?? http.Client(),
        _token = token ?? AppConfig.tmdbReadToken,
        _baseUri = baseUri ?? Uri.https('api.themoviedb.org', '/3');

  final http.Client _client;
  final String _token;
  final Uri _baseUri;
  final Duration timeout;

  Future<Object?> getJson(
    String endpoint, {
    Map<String, String> queryParameters = const {},
  }) async {
    if (_token.isEmpty || _token == 'PASTE_YOUR_TOKEN_HERE') {
      throw const CatalogException.unauthorized();
    }

    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final uri = _baseUri.replace(
      path: '${_baseUri.path}/$normalizedEndpoint',
      queryParameters: {'language': 'en-US', ...queryParameters},
    );

    late final http.Response response;
    try {
      response = await _client
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
            },
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const CatalogException.network();
    } on http.ClientException {
      throw const CatalogException.network();
    } on Object {
      throw const CatalogException.network();
    }

    switch (response.statusCode) {
      case 401:
        throw const CatalogException.unauthorized();
      case 404:
        throw const CatalogException.notFound();
      case 429:
        throw const CatalogException.rateLimited();
      case >= 500:
        throw const CatalogException.server();
      case >= 400:
        throw const CatalogException.network();
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const CatalogException.parse();
    }
  }
}
