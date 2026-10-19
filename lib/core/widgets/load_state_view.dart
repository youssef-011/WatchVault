import 'package:flutter/material.dart';

import '../../features/library/application/library_controller.dart';
import 'empty_state.dart';

class LoadStateView extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.controller,
    required this.childBuilder,
  });

  final LibraryController controller;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return switch (controller.loadState) {
          LibraryLoadState.loading => const Center(
              child: CircularProgressIndicator(),
            ),
          LibraryLoadState.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmptyState(
                    icon: Icons.error_outline,
                    title: 'Something went wrong',
                    subtitle: controller.errorMessage ?? 'Please try again.',
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: controller.load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          LibraryLoadState.ready => childBuilder(context),
        };
      },
    );
  }
}
