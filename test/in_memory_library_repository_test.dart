import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  const media = MediaItem(
    id: 42,
    title: 'A title',
    type: MediaType.movie,
  );
  final libraryItem = LibraryItem(
    media: media,
    entry: LibraryEntry(
      mediaKey: media.key,
      status: WatchStatus.wantToWatch,
      addedAt: DateTime.utc(2026),
    ),
  );

  test('repository starts empty', () async {
    final repository = InMemoryLibraryRepository();
    expect(await repository.loadItems(), isEmpty);
  });

  test('save upserts and load returns an independent list', () async {
    final repository = InMemoryLibraryRepository();
    await repository.save(libraryItem);
    await repository.save(libraryItem.copyWith(
      entry: libraryItem.entry.copyWith(status: WatchStatus.watching),
    ));
    final items = await repository.loadItems();
    expect(items, hasLength(1));
    expect(items.single.entry.status, WatchStatus.watching);
    items.clear();
    expect(await repository.loadItems(), hasLength(1));
  });

  test('remove deletes the matching media key', () async {
    final repository = InMemoryLibraryRepository(initial: [libraryItem]);
    await repository.remove(media.key);
    expect(await repository.loadItems(), isEmpty);
  });
}
