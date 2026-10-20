import 'package:flutter/material.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/data/tmdb_image_url.dart';

import 'poster_placeholder.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final posterPath = item.posterPath;
    final imageUrl = posterUrl(posterPath, size: 'w500');
    if (imageUrl == null) {
      return PosterPlaceholder(item: item);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null ? child : PosterPlaceholder(item: item),
      errorBuilder: (context, error, stackTrace) =>
          PosterPlaceholder(item: item),
    );
  }
}
