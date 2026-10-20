import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/data/mock_library.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  test(
    'initial data is copied and returned collections are independent',
    () async {
      final repository = InMemoryLibraryRepository();
      final catalog = await repository.loadCatalog();
      final entries = await repository.loadEntries();

      expect(catalog, mockMedia);
      expect(entries, mockLibrary);
      catalog.clear();
      entries.clear();
      expect((await repository.loadCatalog()).length, mockMedia.length);
      expect((await repository.loadEntries()).length, mockLibrary.length);
    },
  );

  test('saveEntry upserts entries and new media', () async {
    final repository = InMemoryLibraryRepository();
    final original = mockLibrary.first;
    final updated = LibraryEntry(
      mediaKey: original.mediaKey,
      status: WatchStatus.watching,
      addedAt: original.addedAt,
    );
    const manualMedia = MediaItem(
      id: -1,
      title: 'Manual title',
      type: MediaType.movie,
    );
    final manualEntry = LibraryEntry(
      mediaKey: manualMedia.key,
      status: WatchStatus.wantToWatch,
      addedAt: DateTime.utc(2026),
    );

    await repository.saveEntry(updated);
    await repository.saveEntry(manualEntry, newMedia: manualMedia);

    final entries = await repository.loadEntries();
    expect(
      entries.where((entry) => entry.mediaKey == original.mediaKey).toList(),
      [updated],
    );
    expect(
      entries.where((entry) => entry.mediaKey == manualEntry.mediaKey).toList(),
      [manualEntry],
    );
    expect(await repository.loadCatalog(), contains(manualMedia));
  });

  test('removeEntry removes the matching entry', () async {
    final repository = InMemoryLibraryRepository();
    final key = mockLibrary.first.mediaKey;

    await repository.removeEntry(key);

    expect(
      (await repository.loadEntries()).any((entry) => entry.mediaKey == key),
      isFalse,
    );
  });

  test('upserts distinguish movie and series keys with the same id', () async {
    final repository = InMemoryLibraryRepository(catalog: [], entries: []);
    const movie = MediaItem(
      id: 42,
      title: 'Movie',
      type: MediaType.movie,
    );
    const series = MediaItem(
      id: 42,
      title: 'Series',
      type: MediaType.series,
    );
    final movieEntry = LibraryEntry(
      mediaKey: movie.key,
      status: WatchStatus.watching,
      addedAt: DateTime.utc(2026, 1, 1),
    );
    final seriesEntry = LibraryEntry(
      mediaKey: series.key,
      status: WatchStatus.watched,
      addedAt: DateTime.utc(2026, 1, 2),
    );

    await repository.saveEntry(movieEntry, newMedia: movie);
    await repository.saveEntry(seriesEntry, newMedia: series);

    expect(await repository.loadCatalog(), [movie, series]);
    expect(await repository.loadEntries(), [movieEntry, seriesEntry]);
  });

  test('manual title remains available after reload', () async {
    final repository = InMemoryLibraryRepository();
    const media = MediaItem(
      id: -7,
      title: 'Persisted in memory',
      type: MediaType.series,
    );
    final entry = LibraryEntry(
      mediaKey: media.key,
      status: WatchStatus.watched,
      userRating: 4.5,
      addedAt: DateTime.utc(2026, 1, 1),
    );

    await repository.saveEntry(entry, newMedia: media);

    final reloadedCatalog = await repository.loadCatalog();
    final reloadedEntries = await repository.loadEntries();
    expect(reloadedCatalog, contains(media));
    expect(reloadedEntries, contains(entry));
  });
}
