import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/library_repository.dart';

class FailingLibraryRepository implements LibraryRepository {
  FailingLibraryRepository({
    Iterable<LibraryItem> initial = const [],
    this.failLoads = false,
    this.failMutations = true,
  }) : _items = List<LibraryItem>.of(initial);

  final bool failLoads;
  final bool failMutations;
  final List<LibraryItem> _items;

  @override
  Future<List<LibraryItem>> loadItems() async {
    if (failLoads) throw StateError('Repository load failed');
    return List<LibraryItem>.of(_items);
  }

  @override
  Future<void> save(LibraryItem item) async {
    if (failMutations) throw StateError('Repository save failed');
    final index = _items.indexWhere((existing) => existing.key == item.key);
    if (index < 0) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
  }

  @override
  Future<void> remove(MediaKey key) async {
    if (failMutations) throw StateError('Repository remove failed');
    _items.removeWhere((item) => item.key == key);
  }
}
