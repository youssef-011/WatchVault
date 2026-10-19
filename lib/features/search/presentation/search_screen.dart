import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../../details/presentation/details_screen.dart';
import '../../home/data/mock_media.dart';
import '../../library/domain/media_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late final List<MediaItem> _allMedia = _collectUniqueMedia();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final normalizedQuery = query.toLowerCase();
    final matches = normalizedQuery.isEmpty
        ? const <MediaItem>[]
        : _allMedia
            .where((item) => item.title.toLowerCase().contains(normalizedQuery))
            .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search movies and series',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          Expanded(
            child: _buildResults(context, query, normalizedQuery, matches),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    String query,
    String normalizedQuery,
    List<MediaItem> matches,
  ) {
    if (normalizedQuery.isEmpty) {
      return const EmptyState(
        icon: Icons.search,
        title: 'Find something to watch',
        subtitle: 'Search by movie or series title.',
      );
    }
    if (matches.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No results for "$query".',
        subtitle: 'Try another movie or series title.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          mediaCardGridPadding,
          0,
          mediaCardGridPadding,
          24,
        ),
        gridDelegate: mediaCardGridDelegate(context, constraints.maxWidth),
        itemCount: matches.length,
        itemBuilder: (context, index) => LayoutBuilder(
          builder: (context, constraints) => MediaCard(
            item: matches[index],
            width: constraints.maxWidth,
            onTap: () => Navigator.of(context).push(
              DetailsScreen.route(matches[index]),
            ),
          ),
        ),
      ),
    );
  }

  List<MediaItem> _collectUniqueMedia() {
    final seenIds = <int>{};
    final items = [...trending, ...popularSeries, ...topRated];
    return items
        .where((item) => seenIds.add(item.id))
        .toList(growable: false);
  }
}
