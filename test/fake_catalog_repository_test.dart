import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';

import 'helpers/fake_catalog_repository.dart';
import 'helpers/mock_media.dart';

void main() {
  test('fake catalog is backed by the curated mock media', () async {
    final repository = FakeCatalogRepository();

    expect(await repository.trending(), mockMedia.take(6).toList());
    expect(
      (await repository.search('  DUNE ')).single,
      mockMedia.first,
    );
    expect(
      (await repository.details(
        const MediaKey(type: MediaType.movie, id: 101),
      )).item,
      mockMedia.first,
    );
  });
}
