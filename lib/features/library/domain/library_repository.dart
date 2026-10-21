import 'package:watchvault/core/models/media_key.dart';

import 'library_item.dart';

abstract interface class LibraryRepository {
  Future<List<LibraryItem>> loadItems();

  Future<void> save(LibraryItem item);

  Future<void> remove(MediaKey key);
}
