import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';

void main() {
  test('MediaKey value round trips and distinguishes overlapping ids', () {
    const movieKey = MediaKey(type: MediaType.movie, id: 42);
    const seriesKey = MediaKey(type: MediaType.series, id: 42);

    expect(movieKey.value, 'movie:42');
    expect(MediaKey.fromValue(movieKey.value), movieKey);
    expect({movieKey, MediaKey.fromValue(movieKey.value)}, hasLength(1));
    expect(seriesKey, isNot(movieKey));
  });

  test('invalid values are rejected', () {
    expect(() => MediaKey.fromValue('unknown:1'), throwsFormatException);
    expect(() => MediaKey.fromValue('movie:abc'), throwsFormatException);
  });
}
