import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';
import 'package:watchvault/features/library/presentation/library_screen.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('library shows three tabs and watched media cards', (tester) async {
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

    expect(find.text('Want to Watch'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);

    await tester.tap(find.text('Watched'));
    await tester.pumpAndSettle();

    expect(find.byType(MediaCard), findsWidgets);
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

    await tester.tap(find.text('Add title'));
    await tester.pumpAndSettle();

    expect(find.text('Overview (optional)'), findsOneWidget);
  });

  testWidgets('empty library tab shows its message and Add title action', (
    tester,
  ) async {
    final controller = LibraryController(
      repository: InMemoryLibraryRepository(entries: const []),
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

    expect(controller.countFor(WatchStatus.wantToWatch), 3);
    expect(controller.countFor(WatchStatus.watching), 3);
    await tester.longPress(find.byType(MediaCard).first);
    await tester.pumpAndSettle();

    expect(find.text('Remove from library'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Watching'));
    await tester.pumpAndSettle();

    expect(controller.countFor(WatchStatus.wantToWatch), 2);
    expect(controller.countFor(WatchStatus.watching), 4);
  });
}
