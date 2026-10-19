import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
        icon: Icons.movie_outlined,
        title: 'Welcome to WatchVault',
        subtitle: 'Your next favorite story starts here.',
      );
}
