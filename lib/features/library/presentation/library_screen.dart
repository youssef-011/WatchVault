import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/load_state_view.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../application/library_controller.dart';
import '../application/library_scope.dart';
import '../domain/add_title_result.dart';
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
    final controller = LibraryScope.of(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: TabBar(
            tabs: [for (final tab in _tabs) Tab(text: tab.label)],
          ),
        ),
        body: LoadStateView(
          controller: controller,
          childBuilder: (context) => TabBarView(
            children: [
              for (final tab in _tabs)
                _LibraryGrid(tab: tab, controller: controller),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.of(context)
                  .pushNamed<AddTitleResult>(AppRoutes.addTitle);
              if (!context.mounted || result == null) {
                return;
              }
              await controller.addTitle(result);
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.errorMessage ?? 'Added'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add title'),
          ),
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
  const _LibraryGrid({required this.tab, required this.controller});

  final _LibraryTab tab;
  final LibraryController controller;

  @override
  Widget build(BuildContext context) {
    final entries = controller.entriesByStatus(tab.status);

    if (entries.isEmpty) {
      return EmptyState(
        icon: tab.emptyIcon,
        title: tab.emptyTitle,
        subtitle: tab.emptySubtitle,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          mediaCardGridPadding,
          16,
          mediaCardGridPadding,
          24,
        ),
        gridDelegate: mediaCardGridDelegate(context, constraints.maxWidth),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final item = controller.mediaById(entry.mediaId);
          if (item == null) {
            return const SizedBox.shrink();
          }
          return LayoutBuilder(
            builder: (context, constraints) => MediaCard(
              item: item,
              width: constraints.maxWidth,
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.details,
                arguments: item,
              ),
              userRating: tab.status == WatchStatus.watched
                  ? entry.userRating
                  : null,
            ),
          );
        },
      ),
    );
  }
}


