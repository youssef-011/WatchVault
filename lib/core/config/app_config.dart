abstract final class AppConfig {
  static const String tmdbReadToken =
      String.fromEnvironment('TMDB_READ_TOKEN');

  static bool get hasTmdbToken =>
      tmdbReadToken.isNotEmpty &&
      tmdbReadToken != 'PASTE_YOUR_TOKEN_HERE';
}
