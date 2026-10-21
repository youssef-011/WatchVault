import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';

import 'library_entry.dart';

class LibraryItem {
  LibraryItem({required this.media, required this.entry})
      : assert(entry.mediaKey == media.key);

  final MediaItem media;
  final LibraryEntry entry;

  MediaKey get key => media.key;

  LibraryItem copyWith({MediaItem? media, LibraryEntry? entry}) =>
      LibraryItem(media: media ?? this.media, entry: entry ?? this.entry);

  Map<String, Object?> toMap() => {
        'media': media.toMap(),
        'entry': entry.toMap(),
      };

  factory LibraryItem.fromMap(Map<String, Object?> map) => LibraryItem(
        media: MediaItem.fromMap(
          Map<String, Object?>.from(map['media']! as Map),
        ),
        entry: LibraryEntry.fromMap(
          Map<String, Object?>.from(map['entry']! as Map),
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryItem && other.media == media && other.entry == entry;

  @override
  int get hashCode => Object.hash(media, entry);
}
