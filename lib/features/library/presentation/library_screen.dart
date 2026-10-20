import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/router/details_route_arguments.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/load_state_view.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../application/library_controller.dart';
import '../application/library_scope.dart';
import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/watch_status.dart';
import '../domain/watch_status_label.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = [
    _LibraryTab(
      status: WatchStatus.wantToWatch,
      label: 'Want to Watch',
      emptyIcon: Icons.bookmark_border,
      emptyTitle: 'Nothing on your list yet',
      emptySubtitle: 'Save movies and series you want to watch.',
    ),
    _LibraryTab(
      status: WatchStatus.watching,
      label: 'Watching',
      emptyIcon: Icons.play_circle_outline,
      emptyTitle: 'Not watching anything',
      emptySubtitle: 'Titles you are watching will appear here.',
    ),
    _LibraryTab(
      status: WatchStatus.watched,
      label: 'Watched',
      emptyIcon: Icons.check_circle_outline,
      emptyTitle: 'No finished titles yet',
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
            onPressed: () => _openAddTitle(context, controller),
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
      return RefreshIndicator(
        onRefresh: controller.load,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: EmptyState(
                  icon: tab.emptyIcon,
                  title: tab.emptyTitle,
                  subtitle: tab.emptySubtitle,
                  action: FilledButton.tonal(
                    onPressed: () => _openAddTitle(context, controller),
                    child: const Text('Add title'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.load,
      child: LayoutBuilder(
        builder: (context, constraints) => GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            mediaCardGridPadding,
            AppSpacing.lg,
            mediaCardGridPadding,
            AppSpacing.xl,
          ),
          gridDelegate: mediaCardGridDelegate(context, constraints.maxWidth),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final item = controller.mediaByKey(entry.mediaKey);
            if (item == null) {
              return const SizedBox.shrink();
            }
            final heroTag = 'library-${tab.status.name}-${item.key.value}';
            return LayoutBuilder(
              builder: (context, constraints) => MediaCard(
                item: item,
                heroTag: heroTag,
                width: constraints.maxWidth,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.details,
                  arguments: DetailsRouteArguments(
                    item: item,
                    heroTag: heroTag,
                  ),
                ),
                onLongPress: () => unawaited(
                  _showQuickActions(context, controller, entry),
                ),
                userRating: tab.status == WatchStatus.watched
                    ? entry.userRating
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _openAddTitle(
  BuildContext context,
  LibraryController controller,
) async {
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
    SnackBar(content: Text(controller.errorMessage ?? 'Added')),
  );
}

Future<void> _showQuickActions(
  BuildContext context,
  LibraryController controller,
  LibraryEntry entry,
) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final status in WatchStatus.values)
            ListTile(
              title: Text(status.label),
              trailing: status == entry.status
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.of(sheetContext).pop();
                unawaited(
                  _runEntryMutation(
                    context,
                    controller,
                    () => controller.setStatus(entry.mediaKey, status),
                  ),
                );
              },
            ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Remove from library'),
            onTap: () {
              Navigator.of(sheetContext).pop();
              unawaited(
                _runEntryMutation(
                  context,
                  controller,
                  () => controller.removeEntry(entry.mediaKey),
                  successMessage: 'Removed from library',
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    ),
  );
}

Future<void> _runEntryMutation(
  BuildContext context,
  LibraryController controller,
  Future<void> Function() mutation, {
  String? successMessage,
}) async {
  await mutation();
  if (!context.mounted) {
    return;
  }
  final message = controller.errorMessage ?? successMessage;
  if (message != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
