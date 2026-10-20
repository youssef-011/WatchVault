import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_repository.dart';

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
  Future<void> removeEntry(MediaKey mediaKey) async {
    if (failMutations) throw StateError('Repository remove failed');
    await _delegate.removeEntry(mediaKey);
  }
}
