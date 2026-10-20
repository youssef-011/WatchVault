import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';

import '../domain/library_entry.dart';
import '../domain/watch_status.dart';

// DateTime values are runtime objects, so this list cannot be const.
final List<LibraryEntry> mockLibrary = List<LibraryEntry>.unmodifiable([
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.movie, id: 101),
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 8),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.movie, id: 103),
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 12),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.movie, id: 105),
    status: WatchStatus.wantToWatch,
    addedAt: DateTime.utc(2025, 1, 18),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 102),
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 4),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 104),
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 10),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 106),
    status: WatchStatus.watching,
    addedAt: DateTime.utc(2025, 1, 16),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 108),
    status: WatchStatus.watched,
    userRating: 4.5,
    addedAt: DateTime.utc(2024, 12, 20),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 110),
    status: WatchStatus.watched,
    userRating: 5.0,
    addedAt: DateTime.utc(2024, 12, 28),
  ),
  LibraryEntry(
    mediaKey: const MediaKey(type: MediaType.series, id: 112),
    status: WatchStatus.watched,
    userRating: 4.0,
    addedAt: DateTime.utc(2025, 1, 2),
  ),
]);

