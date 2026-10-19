import 'package:flutter/material.dart';

import '../../features/library/domain/media_item.dart';
import 'poster_placeholder.dart';

const String tmdbPosterBaseUrl = 'https://image.tmdb.org/t/p/w500';

class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final posterPath = item.posterPath;
    if (posterPath == null) {
      return PosterPlaceholder(item: item);
    }

    final separator = posterPath.startsWith('/') ? '' : '/';
    return Image.network(
      '$tmdbPosterBaseUrl$separator$posterPath',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null ? child : PosterPlaceholder(item: item),
      errorBuilder: (context, error, stackTrace) =>
          PosterPlaceholder(item: item),
    );
  }
}
