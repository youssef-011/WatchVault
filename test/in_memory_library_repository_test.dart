import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/data/mock_library.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/media_item.dart';
import 'package:watchvault/features/library/domain/media_type.dart';
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
      mediaId: original.mediaId,
      status: WatchStatus.watching,
      addedAt: original.addedAt,
    );
    const manualMedia = MediaItem(
      id: -1,
      title: 'Manual title',
      type: MediaType.movie,
    );
    final manualEntry = LibraryEntry(
      mediaId: -1,
      status: WatchStatus.wantToWatch,
      addedAt: DateTime.utc(2026),
    );

    await repository.saveEntry(updated);
    await repository.saveEntry(manualEntry, newMedia: manualMedia);

    final entries = await repository.loadEntries();
    expect(
      entries.where((entry) => entry.mediaId == original.mediaId).toList(),
      [updated],
    );
    expect(
      entries.where((entry) => entry.mediaId == -1).toList(),
      [manualEntry],
    );
    expect(await repository.loadCatalog(), contains(manualMedia));
  });

  test('removeEntry removes the matching entry', () async {
    final repository = InMemoryLibraryRepository();
    final id = mockLibrary.first.mediaId;

    await repository.removeEntry(id);

    expect(
      (await repository.loadEntries()).any((entry) => entry.mediaId == id),
      isFalse,
    );
  });

  test('manual title remains available after reload', () async {
    final repository = InMemoryLibraryRepository();
    const media = MediaItem(
      id: -7,
      title: 'Persisted in memory',
      type: MediaType.series,
    );
    final entry = LibraryEntry(
      mediaId: media.id,
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
