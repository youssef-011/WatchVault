import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';

import 'library_entry.dart';

abstract interface class LibraryRepository {
  Future<List<MediaItem>> loadCatalog();

  Future<List<LibraryEntry>> loadEntries();

  Future<void> saveEntry(LibraryEntry entry, {MediaItem? newMedia});

  Future<void> removeEntry(MediaKey mediaKey);
}
