import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
        icon: Icons.person_outline,
        title: 'Your profile',
        subtitle: 'Your WatchVault profile will live here.',
      );
}
