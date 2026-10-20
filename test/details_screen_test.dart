import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/application/library_scope.dart';

import 'helpers/controllable_catalog_repository.dart';
import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('details screen shows the title and overview section', (
    tester,
  ) async {
    final item = mockMedia.first;
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: DetailsScreen(item: item, heroTag: 'details-${item.key.value}'),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text(item.title), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
  });

  testWidgets('details display catalog genres and formatted runtime', (
    tester,
  ) async {
    final item = mockMedia.first;
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: DetailsScreen(item: item, heroTag: 'details-data-${item.key.value}'),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('2h 46m'), findsOneWidget);
  });

  testWidgets('details remain visible when catalog details fail', (tester) async {
    final item = mockMedia.first;
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    final catalog = ControllableCatalogRepository()
      ..failures.add('details');
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: DetailsScreen(item: item, heroTag: 'details-error-${item.key.value}'),
        ),
      ),
      repository: catalog,
    ));
    await tester.pumpAndSettle();

    expect(find.text(item.title), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('No connection. Check your internet and try again.'),
        findsOneWidget);
  });
}


