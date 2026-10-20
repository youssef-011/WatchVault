import 'package:flutter/material.dart';

import '../models/load_status.dart';
import '../theme/app_spacing.dart';
import 'empty_state.dart';

class LoadStateView extends StatelessWidget {
  const LoadStateView({
    super.key,
    required this.status,
    required this.errorMessage,
    required this.onRetry,
    required this.childBuilder,
    this.compact = false,
  });

  final LoadStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;
  final WidgetBuilder childBuilder;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: switch (status) {
        LoadStatus.loading => const Center(
            key: ValueKey(LoadStatus.loading),
            child: CircularProgressIndicator(),
          ),
        LoadStatus.error => Center(
            key: const ValueKey(LoadStatus.error),
            child: compact
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline),
                      Text(
                        errorMessage ?? 'Please try again.',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextButton(onPressed: onRetry, child: const Text('Retry')),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmptyState(
                        icon: Icons.error_outline,
                        title: 'Something went wrong',
                        subtitle: errorMessage ?? 'Please try again.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
          ),
        LoadStatus.ready => KeyedSubtree(
            key: const ValueKey(LoadStatus.ready),
            child: childBuilder(context),
          ),
      },
    );
  }
}
