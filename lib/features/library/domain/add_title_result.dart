import 'package:watchvault/core/models/media_item.dart';

import 'library_entry.dart';

class AddTitleResult {
  const AddTitleResult({required this.mediaItem, required this.libraryEntry});

  final MediaItem mediaItem;
  final LibraryEntry libraryEntry;
}
