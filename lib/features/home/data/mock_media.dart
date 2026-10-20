import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';

const List<MediaItem> mockMedia = [
  MediaItem(
    id: 101,
    title: 'Dune: Part Two',
    type: MediaType.movie,
    year: 2024,
    voteAverage: 8.6,
    overview:
        'Paul Atreides joins the Fremen as he faces the forces that threaten their desert home. His growing influence brings personal choices and a larger struggle into collision.',
  ),
  MediaItem(
    id: 102,
    title: 'The Bear',
    type: MediaType.series,
    year: 2022,
    voteAverage: 8.5,
    overview:
        'A gifted chef returns to Chicago to take over his family’s struggling sandwich shop. In the crowded kitchen, he and his crew try to build something better together.',
  ),
  MediaItem(
    id: 103,
    title: 'Past Lives',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.0,
    overview:
        'Two childhood friends reconnect years after one of them leaves Seoul. Their conversations trace the lives they chose and the possibilities that stayed behind.',
  ),
  MediaItem(
    id: 104,
    title: 'Shōgun',
    type: MediaType.series,
    year: 2024,
    voteAverage: 8.8,
    overview:
        'A shipwrecked English pilot arrives in a Japan divided by political rivalries. His knowledge draws him into the plans of a powerful lord and the people around them.',
  ),
  MediaItem(
    id: 105,
    title: 'Spider-Man: Across the Spider-Verse',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.7,
    overview:
        'Miles Morales is pulled into a network of Spider-heroes from different worlds. A clash over how to protect those worlds forces him to define his own path.',
  ),
  MediaItem(
    id: 106,
    title: 'Severance',
    type: MediaType.series,
    year: 2022,
    voteAverage: 8.7,
    overview:
        'Employees at a mysterious company separate their work memories from their lives outside the office. One worker begins to uncover what that boundary is hiding.',
  ),
  MediaItem(
    id: 107,
    title: 'Oppenheimer',
    type: MediaType.movie,
    year: 2023,
    voteAverage: 8.3,
    overview:
        'Physicist J. Robert Oppenheimer leads a secret wartime effort to develop a new weapon. The scientific achievement follows him into a tense political reckoning.',
  ),
  MediaItem(
    id: 108,
    title: 'The Last of Us',
    type: MediaType.series,
    year: 2023,
    voteAverage: 8.6,
    overview:
        'In a world reshaped by a devastating outbreak, a hardened survivor escorts a teenage girl across the country. Their uneasy partnership grows through danger and loss.',
  ),
  MediaItem(
    id: 109,
    title: 'Everything Everywhere All at Once',
    type: MediaType.movie,
    year: 2022,
    voteAverage: 8.1,
    overview:
        'A laundromat owner is swept into a crisis spanning many versions of her life. She must draw on paths she never took to reconnect with the family beside her.',
  ),
  MediaItem(
    id: 110,
    title: 'Blue Eye Samurai',
    type: MediaType.series,
    year: 2023,
    voteAverage: 8.9,
    overview:
        'A mixed-race swordfighter travels through Edo-era Japan under a hidden identity. A personal quest for vengeance tests the resolve behind that disguise.',
  ),
  MediaItem(
    id: 111,
    title: 'The Grand Budapest Hotel',
    type: MediaType.movie,
    year: 2014,
    voteAverage: 8.1,
    overview:
        'A celebrated hotel concierge and his young protégé become entangled in a dispute over a valuable painting. Their adventures unfold amid a changing European country.',
  ),
  MediaItem(
    id: 112,
    title: 'Chernobyl',
    type: MediaType.series,
    year: 2019,
    voteAverage: 9.0,
    overview:
        'After a reactor accident in the Soviet Union, engineers, officials, and rescuers confront its escalating consequences. Their efforts reveal the human cost of secrecy and delay.',
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
