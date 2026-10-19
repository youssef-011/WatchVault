import '../../library/domain/media_item.dart';
import '../../library/domain/media_type.dart';

const List<MediaItem> mockMedia = [
  MediaItem(
    id: 101,
    title: 'Dune: Part Two',
    type: MediaType.movie,
    year: 2024,
    voteAverage: 8.6,
  ),
  MediaItem(
    id: 102,
    title: 'The Bear',
    type: MediaType.series,
    year: 2022,
    voteAverage: 8.5,
  ),
  MediaItem(
    id: 103,
    title: 'Past Lives',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.0,
  ),
  MediaItem(
    id: 104,
    title: 'Shōgun',
    type: MediaType.series,
    year: 2024,
    voteAverage: 8.8,
  ),
  MediaItem(
    id: 105,
    title: 'Spider-Man: Across the Spider-Verse',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.7,
  ),
  MediaItem(
    id: 106,
    title: 'Severance',
    type: MediaType.series,
    year: 2022,
    voteAverage: 8.7,
  ),
  MediaItem(
    id: 107,
    title: 'Oppenheimer',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.3,
  ),
  MediaItem(
    id: 108,
    title: 'The Last of Us',
    type: MediaType.series,
    year: 2023,
    voteAverage: 8.6,
  ),
  MediaItem(
    id: 109,
    title: 'Everything Everywhere All at Once',
    type: MediaType.movie,
    year: 2022,
    voteAverage: 8.1,
  ),
  MediaItem(
    id: 110,
    title: 'Blue Eye Samurai',
    type: MediaType.series,
    year: 2023,
    voteAverage: 8.9,
  ),
  MediaItem(
    id: 111,
    title: 'The Grand Budapest Hotel',
    type: MediaType.movie,
    year: 2014,
    voteAverage: 8.1,
  ),
  MediaItem(
    id: 112,
    title: 'Chernobyl',
    type: MediaType.series,
    year: 2019,
    voteAverage: 9.0,
  ),
];

List<MediaItem> get trending =>
    List<MediaItem>.unmodifiable(mockMedia.take(6));

List<MediaItem> get popularSeries => List<MediaItem>.unmodifiable(
      mockMedia.where((item) => item.type == MediaType.series).take(6),
    );

List<MediaItem> get topRated {
  final items = mockMedia.toList()
    ..sort((a, b) => b.voteAverage!.compareTo(a.voteAverage!));
  return List<MediaItem>.unmodifiable(items.take(6));
}
