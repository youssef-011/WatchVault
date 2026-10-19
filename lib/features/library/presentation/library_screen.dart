import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/media_card.dart';
import '../../details/presentation/details_screen.dart';
import '../../home/data/mock_media.dart';
import '../data/mock_library.dart';
import '../domain/watch_status.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = [
    _LibraryTab(
      status: WatchStatus.wantToWatch,
      label: 'Want to Watch',
      emptyIcon: Icons.bookmark_border,
      emptyTitle: 'Nothing queued yet',
      emptySubtitle: 'Save movies and series you want to watch.',
    ),
    _LibraryTab(
      status: WatchStatus.watching,
      label: 'Watching',
      emptyIcon: Icons.play_circle_outline,
      emptyTitle: 'Nothing in progress',
      emptySubtitle: 'Titles you are watching will appear here.',
    ),
    _LibraryTab(
      status: WatchStatus.watched,
      label: 'Watched',
      emptyIcon: Icons.check_circle_outline,
      emptyTitle: 'No watched titles yet',
      emptySubtitle: 'Mark a title as watched to see it here.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: TabBar(
            tabs: [for (final tab in _tabs) Tab(text: tab.label)],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in _tabs) _LibraryGrid(tab: tab),
          ],
        ),
      ),
    );
  }
}

class _LibraryTab {
  const _LibraryTab({
    required this.status,
    required this.label,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final WatchStatus status;
  final String label;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
}

class _LibraryGrid extends StatelessWidget {
  const _LibraryGrid({required this.tab});

  final _LibraryTab tab;

  @override
  Widget build(BuildContext context) {
    final entries = mockLibrary
        .where((entry) => entry.status == tab.status)
        .toList(growable: false);

    if (entries.isEmpty) {
      return EmptyState(
        icon: tab.emptyIcon,
        title: tab.emptyTitle,
        subtitle: tab.emptySubtitle,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.54,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final item = mediaById(entry.mediaId);
        if (item == null) {
          return const SizedBox.shrink();
        }
        return MediaCard(
          item: item,
          onTap: () => Navigator.of(context).push(DetailsScreen.route(item)),
          userRating: tab.status == WatchStatus.watched
              ? entry.userRating
              : null,
        );
      },
    );
  }
}






