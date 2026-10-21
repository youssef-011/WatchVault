import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  test('toMap/fromMap round trip preserves the media snapshot and entry', () {
    const media = MediaItem(
      id: -1,
      title: 'Manual Movie',
      type: MediaType.movie,
      year: 2026,
      overview: 'A local snapshot.',
    );
    final item = LibraryItem(
      media: media,
      entry: LibraryEntry(
        mediaKey: media.key,
        status: WatchStatus.watched,
        userRating: 4.5,
        addedAt: DateTime.utc(2026, 1, 2),
      ),
    );
    expect(LibraryItem.fromMap(item.toMap()), item);
  });
}
