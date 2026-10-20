import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/features/catalog/data/tmdb_image_url.dart';

void main() {
  test('builds a poster URL and handles missing paths', () {
    expect(
      posterUrl('/poster.jpg'),
      'https://image.tmdb.org/t/p/w342/poster.jpg',
    );
    expect(
      posterUrl('poster.jpg', size: 'w500'),
      'https://image.tmdb.org/t/p/w500/poster.jpg',
    );
    expect(posterUrl(null), isNull);
    expect(posterUrl('  '), isNull);
  });
}
