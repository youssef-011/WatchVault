import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
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
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (controller.loadState) {
            LibraryLoadState.loading => const Center(
                key: ValueKey(LibraryLoadState.loading),
                child: CircularProgressIndicator(),
              ),
            LibraryLoadState.error => Center(
                key: const ValueKey(LibraryLoadState.error),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmptyState(
                      icon: Icons.error_outline,
                      title: 'Something went wrong',
                      subtitle:
                          controller.errorMessage ?? 'Please try again.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton(
                      onPressed: controller.load,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            LibraryLoadState.ready => KeyedSubtree(
                key: const ValueKey(LibraryLoadState.ready),
                child: childBuilder(context),
              ),
          },
        );
      },
    );
  }
}
