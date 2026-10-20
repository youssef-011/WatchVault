String? posterUrl(String? posterPath, {String size = 'w342'}) {
  if (posterPath == null || posterPath.trim().isEmpty) {
    return null;
  }
  final separator = posterPath.startsWith('/') ? '' : '/';
  return 'https://image.tmdb.org/t/p/$size$separator$posterPath';
}
