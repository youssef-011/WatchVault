enum CatalogFailure {
  network,
  unauthorized,
  notFound,
  rateLimited,
  server,
  parse,
}

class CatalogException implements Exception {
  const CatalogException._(this.failure, this.message);

  const CatalogException.network()
      : this._(CatalogFailure.network, 'Catalog network request failed.');

  const CatalogException.unauthorized()
      : this._(
          CatalogFailure.unauthorized,
          'A valid TMDB read token is required.',
        );

  const CatalogException.notFound()
      : this._(
          CatalogFailure.notFound,
          'The requested catalog item was not found.',
        );

  const CatalogException.rateLimited()
      : this._(
          CatalogFailure.rateLimited,
          'The catalog request limit was reached.',
        );

  const CatalogException.server()
      : this._(CatalogFailure.server, 'The catalog service is unavailable.');

  const CatalogException.parse()
      : this._(CatalogFailure.parse, 'The catalog response could not be read.');

  final CatalogFailure failure;
  final String message;

  @override
  String toString() => 'CatalogException(${failure.name}): $message';
}
