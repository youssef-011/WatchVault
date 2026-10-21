import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_type.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/empty_state.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/library_item.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';
import 'package:watchvault/features/search/presentation/search_screen.dart';

import 'helpers/controllable_catalog_repository.dart';
import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('search filters titles and clears back to the prompt', (
    tester,
  ) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SearchScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.byType(MediaCard), findsWidgets);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Find something to watch'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nonsense');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('No results for “nonsense”'), findsOneWidget);
  });

  testWidgets('search catalog errors show a retry action', (tester) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    final catalog = ControllableCatalogRepository()..failures.add('search');
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SearchScreen(),
        ),
      ),
      repository: catalog,
    ));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('No connection. Check your internet and try again.'),
        findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('search does not include a library-only manual title', (
    tester,
  ) async {
    const manualMedia = MediaItem(
      id: -1,
      title: 'Private Manual Title',
      type: MediaType.movie,
    );
    final controller = await createLoadedLibraryController(
      initial: [
        LibraryItem(
          media: manualMedia,
          entry: LibraryEntry(
            mediaKey: manualMedia.key,
            status: WatchStatus.wantToWatch,
            addedAt: DateTime.utc(2026),
          ),
        ),
      ],
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SearchScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Private Manual Title');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('No results for “Private Manual Title”'), findsOneWidget);
  });
}
