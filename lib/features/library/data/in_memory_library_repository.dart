import 'package:watchvault/core/models/media_key.dart';

import '../domain/library_item.dart';
import '../domain/library_repository.dart';

class InMemoryLibraryRepository implements LibraryRepository {
  InMemoryLibraryRepository({Iterable<LibraryItem>? initial})
      : _items = List<LibraryItem>.of(initial ?? const []);

  final List<LibraryItem> _items;

  @override
  Future<List<LibraryItem>> loadItems() async => List<LibraryItem>.of(_items);

  @override
  Future<void> save(LibraryItem item) async {
    final index = _items.indexWhere((existing) => existing.key == item.key);
    if (index < 0) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
  }

  @override
  Future<void> remove(MediaKey key) async {
    _items.removeWhere((item) => item.key == key);
  }
}
