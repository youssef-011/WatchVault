import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/load_state_view.dart';
import '../../library/application/library_scope.dart';
import '../../library/domain/watch_status.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LibraryScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => _showComingSoon(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => LoadStateView(
          status: controller.loadState,
          errorMessage: controller.errorMessage,
          onRetry: () => unawaited(controller.load()),
          childBuilder: (context) {
            final averageRating = controller.averageRating;
            final theme = Theme.of(context);
            return RefreshIndicator(
              onRefresh: controller.load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: CircleAvatar(
                              radius: 48,
                              child: Icon(Icons.person, size: 48),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Movie Lover',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Your personal movie shelf',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.lg,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatItem(
                                      count: controller
                                          .countFor(WatchStatus.wantToWatch),
                                      label: 'Want to Watch',
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 48,
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  Expanded(
                                    child: _StatItem(
                                      count: controller
                                          .countFor(WatchStatus.watching),
                                      label: 'Watching',
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 48,
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  Expanded(
                                    child: _StatItem(
                                      count: controller
                                          .countFor(WatchStatus.watched),
                                      label: 'Watched',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Average rating',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              if (averageRating != null)
                                Icon(
                                  Icons.star_rounded,
                                  color: theme.colorScheme.tertiary,
                                ),
                              Text(
                                averageRating?.toStringAsFixed(1) ?? '—',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _showComingSoon(context),
                            child: const Text('Sign in'),
                          ),
                          OutlinedButton(
                            onPressed: () => _showComingSoon(context),
                            child: const Text('Edit profile'),
                          ),
                          TextButton(
                            onPressed: () => _showComingSoon(context),
                            child: const Text('About'),
                          ),
                          const Card(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: Text(
                                'This product uses the TMDB API but is not endorsed or certified by TMDB.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('$count', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
