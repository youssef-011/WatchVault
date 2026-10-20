import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  test('toMap and fromMap preserve a library entry', () {
    final entry = LibraryEntry(
      mediaKey: const MediaKey(type: MediaType.movie, id: 42),
      status: WatchStatus.watching,
      userRating: 4.5,
      addedAt: DateTime.utc(2025, 3, 12, 14, 30),
    );

    expect(LibraryEntry.fromMap(entry.toMap()), entry);
    expect(entry.toMap()['mediaKey'], 'movie:42');
  });

  test('same numeric id can be held for a movie and a series', () {
    final entries = [
      LibraryEntry(
        mediaKey: const MediaKey(type: MediaType.movie, id: 42),
        status: WatchStatus.watching,
        addedAt: DateTime.utc(2025, 3, 12),
      ),
      LibraryEntry(
        mediaKey: const MediaKey(type: MediaType.series, id: 42),
        status: WatchStatus.watched,
        addedAt: DateTime.utc(2025, 3, 13),
      ),
    ];

    expect(entries[0].mediaKey, isNot(entries[1].mediaKey));
    expect(
      entries.map((entry) => LibraryEntry.fromMap(entry.toMap())).toList(),
      entries,
    );
  });
}
