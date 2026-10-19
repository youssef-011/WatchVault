import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
        icon: Icons.video_library_outlined,
        title: 'Your library is empty',
        subtitle: 'Titles you save will appear here.',
      );
}
