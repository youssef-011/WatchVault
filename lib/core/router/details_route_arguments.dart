import 'package:watchvault/core/models/media_item.dart';

class DetailsRouteArguments {
  const DetailsRouteArguments({required this.item, required this.heroTag});

  final MediaItem item;
  final String heroTag;

  bool get isValid => heroTag.trim().isNotEmpty;
}
