import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';
import 'package:watchvault/features/library/presentation/library_screen.dart';

import 'helpers/library_test_helpers.dart';
import 'helpers/mock_media.dart';

List<LibraryItem> _initialItems() => [
      for (var index = 0; index < 3; index++)
        LibraryItem(
          media: mockMedia[index],
          entry: LibraryEntry(
            mediaKey: mockMedia[index].key,
            status: WatchStatus.values[index],
            userRating: index == 2 ? 4.5 : null,
            addedAt: DateTime.utc(2026, index + 1),
          ),
        ),
    ];

void main() {
  testWidgets('library shows three tabs and watched media cards', (tester) async {
    final controller = await createLoadedLibraryController(
      initial: _initialItems(),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Want to Watch'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);
    await tester.tap(find.text('Watched'));
    await tester.pumpAndSettle();
    expect(find.byType(MediaCard), findsOneWidget);
    expect(find.byTooltip('Watched'), findsOneWidget);
  });

  testWidgets('library Add title button opens the form', (tester) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add title'));
    await tester.pumpAndSettle();
    expect(find.text('Overview (optional)'), findsOneWidget);
  });

  testWidgets('empty library tab shows its message and Add title action', (
    tester,
  ) async {
    final controller = LibraryController(
      repository: InMemoryLibraryRepository(),
    );
    addTearDown(controller.dispose);
    await controller.load();
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nothing on your list yet'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Add title'), findsOneWidget);
  });

  testWidgets('long-press quick actions move an entry between tabs', (
    tester,
  ) async {
    final controller = await createLoadedLibraryController(
      initial: _initialItems(),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.countFor(WatchStatus.wantToWatch), 1);
    expect(controller.countFor(WatchStatus.watching), 1);
    await tester.longPress(find.byType(MediaCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Remove from library'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Watching'));
    await tester.pumpAndSettle();
    expect(controller.countFor(WatchStatus.wantToWatch), 0);
    expect(controller.countFor(WatchStatus.watching), 2);
  });
}
