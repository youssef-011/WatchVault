import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
        icon: Icons.search,
        title: 'Find something to watch',
        subtitle: 'Search for movies and series to add to your library.',
      );
}
