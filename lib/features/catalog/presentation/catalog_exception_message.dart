import 'package:watchvault/features/catalog/data/catalog_exception.dart';

extension CatalogExceptionMessage on CatalogException {
  String get userMessage => switch (failure) {
        CatalogFailure.network =>
          'No connection. Check your internet and try again.',
        CatalogFailure.unauthorized =>
          'TMDB token is missing or invalid. See README.',
        CatalogFailure.rateLimited =>
          'Too many requests. Try again in a moment.',
        CatalogFailure.notFound => 'Not found.',
        CatalogFailure.server || CatalogFailure.parse =>
          'Something went wrong. Try again.',
      };
}
