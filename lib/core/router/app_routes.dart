import 'package:flutter/material.dart';

import '../../features/details/presentation/details_screen.dart';
import '../../features/library/domain/add_title_result.dart';
import '../../features/library/domain/media_item.dart';
import '../../features/library/presentation/add_title_screen.dart';
import '../widgets/empty_state.dart';

abstract final class AppRoutes {
  static const details = '/details';
  static const addTitle = '/add-title';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case details:
        final arguments = settings.arguments;
        if (arguments is MediaItem) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => DetailsScreen(item: arguments),
          );
        }
      case addTitle:
        if (settings.arguments == null) {
          return MaterialPageRoute<AddTitleResult>(
            settings: settings,
            builder: (_) => const AddTitleScreen(),
          );
        }
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const NotFoundScreen(),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: const EmptyState(
        icon: Icons.search_off,
        title: 'Page not found',
        subtitle: 'The requested page is unavailable.',
      ),
    );
  }
}
