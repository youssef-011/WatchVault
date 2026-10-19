import 'package:flutter/material.dart';

import '../../../features/library/data/mock_library.dart';
import '../../../features/library/domain/watch_status.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var wantToWatchCount = 0;
    var watchingCount = 0;
    var watchedCount = 0;
    var ratingTotal = 0.0;
    var ratedEntryCount = 0;

    for (final entry in mockLibrary) {
      switch (entry.status) {
        case WatchStatus.wantToWatch:
          wantToWatchCount++;
          break;
        case WatchStatus.watching:
          watchingCount++;
          break;
        case WatchStatus.watched:
          watchedCount++;
          break;
      }
      if (entry.userRating != null) {
        ratingTotal += entry.userRating!;
        ratedEntryCount++;
      }
    }

    final averageRating =
        ratedEntryCount == 0 ? null : ratingTotal / ratedEntryCount;
    final theme = Theme.of(context);

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
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      child: Icon(Icons.person, size: 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Movie Lover',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your personal movie shelf',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatItem(
                              count: wantToWatchCount,
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
                              count: watchingCount,
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
                              count: watchedCount,
                              label: 'Watched',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Average rating',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      if (averageRating != null) ...[
                        Icon(
                          Icons.star_rounded,
                          color: theme.colorScheme.tertiary,
                        ),
                        Text(
                          '${averageRating.toStringAsFixed(1)} / 5',
                          style: theme.textTheme.titleMedium,
                        ),
                      ] else
                        Text(
                          'No ratings yet',
                          style: theme.textTheme.bodyMedium,
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
                ],
              ),
            ),
          ),
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
  const _StatItem({
    required this.count,
    required this.label,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('$count', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
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


