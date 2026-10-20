import 'package:watchvault/core/models/media_key.dart';

import 'watch_status.dart';

class LibraryEntry {
  LibraryEntry({
    required this.mediaKey,
    required this.status,
    required this.addedAt,
    this.userRating,
  }) : assert(
          userRating == null ||
              (userRating >= 0.5 &&
                  userRating <= 5.0 &&
                  userRating * 2 == (userRating * 2).round()),
          'userRating must be null or a half-step from 0.5 to 5.0.',
        );

  final MediaKey mediaKey;
  final WatchStatus status;
  final double? userRating;
  final DateTime addedAt;

  LibraryEntry copyWith({
    MediaKey? mediaKey,
    WatchStatus? status,
    double? userRating,
    DateTime? addedAt,
  }) {
    return LibraryEntry(
      mediaKey: mediaKey ?? this.mediaKey,
      status: status ?? this.status,
      userRating: userRating ?? this.userRating,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, Object?> toMap() => {
        'mediaKey': mediaKey.value,
        'status': status.name,
        'userRating': userRating,
        'addedAt': addedAt.toIso8601String(),
      };

  factory LibraryEntry.fromMap(Map<String, Object?> map) {
    return LibraryEntry(
      mediaKey: MediaKey.fromValue(map['mediaKey'] as String),
      status: WatchStatus.values.byName(map['status'] as String),
      userRating: (map['userRating'] as num?)?.toDouble(),
      addedAt: DateTime.parse(map['addedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryEntry &&
          other.mediaKey == mediaKey &&
          other.status == status &&
          other.userRating == userRating &&
          other.addedAt == addedAt;

  @override
  int get hashCode => Object.hash(mediaKey, status, userRating, addedAt);
}
