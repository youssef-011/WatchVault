import 'library_entry.dart';
import 'media_item.dart';

abstract interface class LibraryRepository {
  Future<List<MediaItem>> loadCatalog();

  Future<List<LibraryEntry>> loadEntries();

  Future<void> saveEntry(LibraryEntry entry, {MediaItem? newMedia});

  Future<void> removeEntry(int mediaId);
}
