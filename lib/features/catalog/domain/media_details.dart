import 'package:watchvault/core/models/media_item.dart';

class MediaDetails {
  const MediaDetails({
    required this.item,
    this.tagline,
    this.genres = const [],
    this.runtimeMinutes,
    this.seasons,
  });

  final MediaItem item;
  final String? tagline;
  final List<String> genres;
  final int? runtimeMinutes;
  final int? seasons;
}
