import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_repository.dart';
import 'package:watchvault/features/library/domain/media_item.dart';

class FailingLibraryRepository implements LibraryRepository {
  FailingLibraryRepository({
    this.failLoads = false,
    this.failMutations = true,
  });

  final bool failLoads;
  final bool failMutations;
  final InMemoryLibraryRepository _delegate = InMemoryLibraryRepository();

  @override
  Future<List<MediaItem>> loadCatalog() {
    if (failLoads) throw StateError('Repository load failed');
    return _delegate.loadCatalog();
  }

  @override
  Future<List<LibraryEntry>> loadEntries() {
    if (failLoads) throw StateError('Repository load failed');
    return _delegate.loadEntries();
  }

  @override
  Future<void> saveEntry(LibraryEntry entry, {MediaItem? newMedia}) async {
    if (failMutations) throw StateError('Repository save failed');
    await _delegate.saveEntry(entry, newMedia: newMedia);
  }

  @override
  Future<void> removeEntry(int mediaId) async {
    if (failMutations) throw StateError('Repository remove failed');
    await _delegate.removeEntry(mediaId);
  }
}
