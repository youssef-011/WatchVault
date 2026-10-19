import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/domain/add_title_result.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/media_item.dart';
import 'package:watchvault/features/library/domain/media_type.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  test('addTitle uses a unique negative catalog id and adds its entry', () {
    final controller = LibraryController();
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

    final addedItem = controller.addTitle(result);

    expect(addedItem.id, lessThan(0));
    expect(controller.mediaById(addedItem.id), addedItem);
    expect(controller.entryFor(addedItem.id)?.userRating, 4.5);
    expect(controller.entryFor(addedItem.id)?.status, WatchStatus.watched);
    expect(controller.addTitle(result).id, lessThan(addedItem.id));
  });

  test('setStatus clears ratings when an entry leaves watched', () {
    final controller = LibraryController();
    addTearDown(controller.dispose);

    controller.setStatus(101, WatchStatus.watched);
    controller.setRating(101, 4.5);
    expect(controller.entryFor(101)?.userRating, 4.5);

    controller.setStatus(101, WatchStatus.watching);

    expect(controller.entryFor(101)?.status, WatchStatus.watching);
    expect(controller.entryFor(101)?.userRating, isNull);
  });

  test('setRating accepts half steps and rejects other values', () {
    final controller = LibraryController();
    addTearDown(controller.dispose);
    controller.setStatus(101, WatchStatus.watched);

    controller.setRating(101, 3.5);
    expect(controller.entryFor(101)?.userRating, 3.5);
    expect(() => controller.setRating(101, 3.2), throwsArgumentError);

    controller.setRating(101, null);
    expect(controller.entryFor(101)?.userRating, isNull);
  });

  test('counts statuses and returns null average when none are rated', () {
    final controller = LibraryController(
      catalog: mockMedia,
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
    );
    addTearDown(controller.dispose);

    expect(controller.countFor(WatchStatus.wantToWatch), 1);
    expect(controller.countFor(WatchStatus.watched), 1);
    expect(controller.averageRating, isNull);
  });

  test('average rating includes only rated watched entries', () {
    final controller = LibraryController();
    addTearDown(controller.dispose);

    expect(controller.averageRating, closeTo((4.5 + 5.0 + 4.0) / 3, 0.001));
    controller.removeEntry(108);
    expect(controller.averageRating, closeTo(4.5, 0.001));
  });

  test('removeEntry removes the entry and not the catalog item', () {
    final controller = LibraryController();
    addTearDown(controller.dispose);

    controller.removeEntry(101);

    expect(controller.entryFor(101), isNull);
    expect(controller.mediaById(101), isNotNull);
  });
}
