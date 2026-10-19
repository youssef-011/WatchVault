import '../domain/library_entry.dart';
import '../domain/watch_status.dart';

// DateTime values are runtime objects, so this list cannot be const.
final List<LibraryEntry> mockLibrary = List<LibraryEntry>.unmodifiable([
  LibraryEntry(
    mediaId: 101,
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 8),
  ),
  LibraryEntry(
    mediaId: 103,
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 12),
  ),
  LibraryEntry(
    mediaId: 105,
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 18),
  ),
  LibraryEntry(
    mediaId: 102,
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 4),
  ),
  LibraryEntry(
    mediaId: 104,
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 10),
  ),
  LibraryEntry(
    mediaId: 106,
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 16),
  ),
  LibraryEntry(
    mediaId: 108,
    status: WatchStatus.watched,
    userRating: 4.5,
    addedAt: DateTime.utc(2024, 12, 20),
  ),
  LibraryEntry(
    mediaId: 110,
    status: WatchStatus.watched,
    userRating: 5.0,
    addedAt: DateTime.utc(2024, 12, 28),
  ),
  LibraryEntry(
    mediaId: 112,
    status: WatchStatus.watched,
    userRating: 4.0,
    addedAt: DateTime.utc(2025, 1, 2),
  ),
]);

