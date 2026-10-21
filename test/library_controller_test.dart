import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/add_title_result.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

import 'helpers/failing_library_repository.dart';

LibraryItem _libraryItem({
  required MediaItem media,
  WatchStatus status = WatchStatus.wantToWatch,
  double? rating,
}) =>
    LibraryItem(
      media: media,
      entry: LibraryEntry(
        mediaKey: media.key,
        status: status,
        userRating: rating,
        addedAt: DateTime.utc(2026),
      ),
    );

Future<LibraryController> _loadedController({Iterable<LibraryItem> initial = const []}) async {
  final controller = LibraryController(
    repository: InMemoryLibraryRepository(initial: initial),
  );
  await controller.load();
  return controller;
}

void main() {
  const dune = MediaItem(id: 101, title: 'Dune', type: MediaType.movie);
  const theBear = MediaItem(id: 102, title: 'The Bear', type: MediaType.series);

  test('add defaults to Want to Watch and duplicate adds are no-ops', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);
    await controller.add(dune);
    await controller.add(dune);
    await controller.setRating(dune.key, 4.5);
    expect(controller.items, hasLength(1));
    expect(controller.itemFor(dune.key)?.media, dune);
    expect(controller.itemFor(dune.key)?.entry.status, WatchStatus.wantToWatch);
    expect(controller.itemFor(dune.key)?.entry.userRating, isNull);
  });

  test('manual title receives a unique negative id per media type', () async {
    final controller = await _loadedController();
    addTearDown(controller.dispose);
    final now = DateTime.utc(2026, 5, 1);
    AddTitleResult result(MediaType type, int id) {
      final media = MediaItem(id: id, title: 'Manual ${type.name}', type: type);
      return AddTitleResult(
        mediaItem: media,
        libraryEntry: LibraryEntry(
          mediaKey: media.key,
          status: WatchStatus.watched,
          userRating: 4.5,
          addedAt: now,
        ),
      );
    }

    await controller.addTitle(result(MediaType.movie, 501));
    await controller.addTitle(result(MediaType.movie, 502));
    await controller.addTitle(result(MediaType.series, 503));
    expect(controller.items.map((item) => item.media.id), [-1, -2, -1]);
    expect(controller.items.every((item) => item.entry.userRating == 4.5), isTrue);
  });

  test('status changes clear ratings when leaving Watched', () async {
    final controller = await _loadedController(initial: [
      _libraryItem(media: theBear, status: WatchStatus.watched, rating: 4.5),
    ]);
    addTearDown(controller.dispose);
    await controller.setStatus(theBear.key, WatchStatus.watching);
    expect(controller.itemFor(theBear.key)?.entry.status, WatchStatus.watching);
    expect(controller.itemFor(theBear.key)?.entry.userRating, isNull);
  });

  test('rating accepts half steps only while Watched', () async {
    final controller = await _loadedController(initial: [
      _libraryItem(media: theBear, status: WatchStatus.watched),
    ]);
    addTearDown(controller.dispose);
    await controller.setRating(theBear.key, 3.5);
    expect(controller.itemFor(theBear.key)?.entry.userRating, 3.5);
    await expectLater(controller.setRating(theBear.key, 3.2), throwsArgumentError);
    await controller.setRating(theBear.key, null);
    expect(controller.itemFor(theBear.key)?.entry.userRating, isNull);
  });

  test('counts and average ratings are computed from library items', () async {
    final controller = await _loadedController(initial: [
      _libraryItem(media: dune),
      _libraryItem(media: theBear, status: WatchStatus.watched),
    ]);
    addTearDown(controller.dispose);
    expect(controller.countFor(WatchStatus.wantToWatch), 1);
    expect(controller.averageRating, isNull);
    await controller.setRating(theBear.key, 4.5);
    expect(controller.averageRating, 4.5);
  });

  test('remove deletes the library item snapshot', () async {
    final controller = await _loadedController(initial: [_libraryItem(media: dune)]);
    addTearDown(controller.dispose);
    await controller.remove(dune.key);
    expect(controller.itemFor(dune.key), isNull);
    expect(controller.isInLibrary(dune.key), isFalse);
  });

  test('failed load enters error state with a message', () async {
    final controller = LibraryController(
      repository: FailingLibraryRepository(failLoads: true),
    );
    addTearDown(controller.dispose);
    await controller.load();
    expect(controller.loadState, LoadStatus.error);
    expect(controller.errorMessage, contains('Unable to load your library'));
  });

  test('failed setStatus rolls back and exposes the error', () async {
    final original = _libraryItem(media: theBear);
    final controller = LibraryController(
      repository: FailingLibraryRepository(initial: [original]),
    );
    addTearDown(controller.dispose);
    await controller.load();
    await controller.setStatus(theBear.key, WatchStatus.watched);
    expect(controller.itemFor(theBear.key), original);
    expect(controller.errorMessage, contains('Unable to update your library'));
  });
}
