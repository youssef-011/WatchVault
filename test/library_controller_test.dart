import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/add_title_result.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

import 'helpers/failing_library_repository.dart';

Future<LibraryController> _loadedController() async {
  final controller = LibraryController(
    repository: InMemoryLibraryRepository(),
  );
  await controller.load();
  return controller;
}

void main() {
  test('addTitle uses a unique negative catalog id and adds its entry', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);
    final now = DateTime.utc(2026, 5, 1);
    final result = AddTitleResult(
      mediaItem: const MediaItem(
        id: 1000,
        title: 'New title',
        type: MediaType.movie,
      ),
      libraryEntry: LibraryEntry(
        mediaKey: const MediaKey(type: MediaType.movie, id: 1000),
        status: WatchStatus.watched,
        userRating: 4.5,
        addedAt: now,
      ),
    );

    await controller.addTitle(result);
    final addedItem = controller.catalog.last;

    expect(addedItem.id, lessThan(0));
    expect(controller.mediaByKey(addedItem.key), addedItem);
    expect(controller.entryFor(addedItem.key)?.userRating, 4.5);
    expect(controller.entryFor(addedItem.key)?.status, WatchStatus.watched);
    await controller.addTitle(result);
    expect(controller.catalog.last.id, lessThan(addedItem.id));
  });

  test('setStatus clears ratings when an entry leaves watched', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);

    const lastOfUs = MediaKey(type: MediaType.series, id: 108);
    await controller.setStatus(lastOfUs, WatchStatus.watched);
    await controller.setRating(lastOfUs, 4.5);
    expect(controller.entryFor(lastOfUs)?.userRating, 4.5);

    await controller.setStatus(lastOfUs, WatchStatus.watching);

    expect(controller.entryFor(lastOfUs)?.status, WatchStatus.watching);
    expect(controller.entryFor(lastOfUs)?.userRating, isNull);
  });

  test('setRating accepts half steps and rejects other values', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);
    const theBear = MediaKey(type: MediaType.series, id: 102);
    await controller.setStatus(theBear, WatchStatus.watched);

    await controller.setRating(theBear, 3.5);
    expect(controller.entryFor(theBear)?.userRating, 3.5);
    await expectLater(controller.setRating(theBear, 3.2), throwsArgumentError);

    await controller.setRating(theBear, null);
    expect(controller.entryFor(theBear)?.userRating, isNull);
  });

  test('counts statuses and returns null average when none are rated', () async {
    final controller = LibraryController(
      repository: InMemoryLibraryRepository(
        entries: [
          LibraryEntry(
            mediaKey: const MediaKey(type: MediaType.movie, id: 101),
            status: WatchStatus.wantToWatch,
            addedAt: DateTime.utc(2026),
          ),
          LibraryEntry(
            mediaKey: const MediaKey(type: MediaType.series, id: 102),
            status: WatchStatus.watched,
            addedAt: DateTime.utc(2026),
          ),
        ],
      ),
    );
    addTearDown(controller.dispose);
    await controller.load();

    expect(controller.countFor(WatchStatus.wantToWatch), 1);
    expect(controller.countFor(WatchStatus.watched), 1);
    expect(controller.averageRating, isNull);
  });

  test('average rating includes only rated watched entries', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);

    expect(controller.averageRating, closeTo((4.5 + 5.0 + 4.0) / 3, 0.001));
    await controller.removeEntry(const MediaKey(type: MediaType.series, id: 108));
    expect(controller.averageRating, closeTo(4.5, 0.001));
  });

  test('removeEntry removes the entry and not the catalog item', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);

    const dune = MediaKey(type: MediaType.movie, id: 101);
    await controller.removeEntry(dune);

    expect(controller.entryFor(dune), isNull);
    expect(controller.mediaByKey(dune), isNotNull);
  });

  test('failed load enters error state with a message', () async {
    final controller = LibraryController(
      repository: FailingLibraryRepository(failLoads: true),
    );
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.loadState, LibraryLoadState.error);
    expect(controller.errorMessage, contains('Unable to load your library'));
  });

  test('failed setStatus rolls back and exposes the error', () async {
    final repository = FailingLibraryRepository();
    final controller = LibraryController(repository: repository);
    addTearDown(controller.dispose);
    await controller.load();
    const theBear = MediaKey(type: MediaType.series, id: 102);
    final original = controller.entryFor(theBear);

    await controller.setStatus(theBear, WatchStatus.watched);

    expect(controller.entryFor(theBear), original);
    expect(controller.errorMessage, contains('Unable to update your library'));
  });
}
