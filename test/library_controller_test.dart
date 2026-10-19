import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/add_title_result.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/media_item.dart';
import 'package:watchvault/features/library/domain/media_type.dart';
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
        mediaId: 1000,
        status: WatchStatus.watched,
        userRating: 4.5,
        addedAt: now,
      ),
    );

    await controller.addTitle(result);
    final addedItem = controller.catalog.last;

    expect(addedItem.id, lessThan(0));
    expect(controller.mediaById(addedItem.id), addedItem);
    expect(controller.entryFor(addedItem.id)?.userRating, 4.5);
    expect(controller.entryFor(addedItem.id)?.status, WatchStatus.watched);
    await controller.addTitle(result);
    expect(controller.catalog.last.id, lessThan(addedItem.id));
  });

  test('setStatus clears ratings when an entry leaves watched', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);

    await controller.setStatus(108, WatchStatus.watched);
    await controller.setRating(108, 4.5);
    expect(controller.entryFor(108)?.userRating, 4.5);

    await controller.setStatus(108, WatchStatus.watching);

    expect(controller.entryFor(108)?.status, WatchStatus.watching);
    expect(controller.entryFor(108)?.userRating, isNull);
  });

  test('setRating accepts half steps and rejects other values', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);
    await controller.setStatus(102, WatchStatus.watched);

    await controller.setRating(102, 3.5);
    expect(controller.entryFor(102)?.userRating, 3.5);
    await expectLater(controller.setRating(102, 3.2), throwsArgumentError);

    await controller.setRating(102, null);
    expect(controller.entryFor(102)?.userRating, isNull);
  });

  test('counts statuses and returns null average when none are rated', () async {
    final controller = LibraryController(
      repository: InMemoryLibraryRepository(
        entries: [
          LibraryEntry(
            mediaId: 101,
            status: WatchStatus.wantToWatch,
            addedAt: DateTime.utc(2026),
          ),
          LibraryEntry(
            mediaId: 102,
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
    await controller.removeEntry(108);
    expect(controller.averageRating, closeTo(4.5, 0.001));
  });

  test('removeEntry removes the entry and not the catalog item', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);

    await controller.removeEntry(101);

    expect(controller.entryFor(101), isNull);
    expect(controller.mediaById(101), isNotNull);
  });

  test('failed load enters error state with a message', () async {
    final controller = LibraryController(
      repository: FailingLibraryRepository(failLoads: true),
    );
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.loadState, LibraryLoadState.error);
    expect(controller.errorMessage, contains('Repository load failed'));
  });

  test('failed setStatus rolls back and exposes the error', () async {
    final repository = FailingLibraryRepository();
    final controller = LibraryController(repository: repository);
    addTearDown(controller.dispose);
    await controller.load();
    final original = controller.entryFor(102);

    await controller.setStatus(102, WatchStatus.watched);

    expect(controller.entryFor(102), original);
    expect(controller.errorMessage, contains('Repository save failed'));
  });
}
