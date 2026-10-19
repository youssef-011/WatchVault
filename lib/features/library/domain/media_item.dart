import 'media_type.dart';

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.type,
    this.posterPath,
    this.overview,
    this.year,
    this.voteAverage,
  });

  final int id;
  final String title;
  final MediaType type;
  final String? posterPath;
  final String? overview;
  final int? year;
  final double? voteAverage;

  MediaItem copyWith({
    int? id,
    String? title,
    MediaType? type,
    String? posterPath,
    String? overview,
    int? year,
    double? voteAverage,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      year: year ?? this.year,
      voteAverage: voteAverage ?? this.voteAverage,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'type': type.name,
        'posterPath': posterPath,
        'overview': overview,
        'year': year,
        'voteAverage': voteAverage,
      };

  factory MediaItem.fromMap(Map<String, Object?> map) {
    return MediaItem(
      id: map['id'] as int,
      title: map['title'] as String,
      type: MediaType.values.byName(map['type'] as String),
      posterPath: map['posterPath'] as String?,
      overview: map['overview'] as String?,
      year: map['year'] as int?,
      voteAverage: (map['voteAverage'] as num?)?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem &&
          other.id == id &&
          other.title == title &&
          other.type == type &&
          other.posterPath == posterPath &&
          other.overview == overview &&
          other.year == year &&
          other.voteAverage == voteAverage;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        type,
        posterPath,
        overview,
        year,
        voteAverage,
      );
}
