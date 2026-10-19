import 'library_entry.dart';
import 'media_item.dart';

class AddTitleResult {
  const AddTitleResult({required this.mediaItem, required this.libraryEntry});

  final MediaItem mediaItem;
  final LibraryEntry libraryEntry;
}
