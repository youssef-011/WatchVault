import '../../home/data/mock_media.dart';
import '../domain/library_entry.dart';
import '../domain/library_repository.dart';
import '../domain/media_item.dart';
import 'mock_library.dart';

class InMemoryLibraryRepository implements LibraryRepository {
  InMemoryLibraryRepository({
    Iterable<MediaItem>? catalog,
    Iterable<LibraryEntry>? entries,
  })  : _catalog = List<MediaItem>.of(catalog ?? mockMedia),
        _entries = List<LibraryEntry>.of(entries ?? mockLibrary);

  final List<MediaItem> _catalog;
  final List<LibraryEntry> _entries;

  @override
  Future<List<MediaItem>> loadCatalog() async => List<MediaItem>.of(_catalog);

  @override
  Future<List<LibraryEntry>> loadEntries() async =>
      List<LibraryEntry>.of(_entries);

  @override
  Future<void> saveEntry(LibraryEntry entry, {MediaItem? newMedia}) async {
    if (newMedia != null) {
      final mediaIndex = _catalog.indexWhere((item) => item.id == newMedia.id);
      if (mediaIndex < 0) {
        _catalog.add(newMedia);
      } else {
        _catalog[mediaIndex] = newMedia;
      }
    }

    final entryIndex =
        _entries.indexWhere((existing) => existing.mediaId == entry.mediaId);
    if (entryIndex < 0) {
      _entries.add(entry);
    } else {
      _entries[entryIndex] = entry;
    }
  }

  @override
  Future<void> removeEntry(int mediaId) async {
    _entries.removeWhere((entry) => entry.mediaId == mediaId);
  }
}
