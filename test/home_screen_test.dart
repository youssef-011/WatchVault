import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/presentation/home_screen.dart';
import 'package:watchvault/features/library/application/library_scope.dart';

import 'helpers/controllable_catalog_repository.dart';
import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('home displays its media sections and cards', (tester) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const HomeScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final mainScrollable = find.byType(Scrollable).first;
    for (final title in [
      'Trending',
      'Popular Movies',
      'Popular Series',
      'Top Rated Movies',
      'Top Rated Series',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title),
        300,
        scrollable: mainScrollable,
      );
      expect(find.text(title), findsOneWidget);
    }

    expect(find.byType(MediaCard), findsWidgets);
  });

  testWidgets('tapping a media card opens its details screen', (tester) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const HomeScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MediaCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(DetailsScreen), findsOneWidget);
  });

  testWidgets('home section heroes have no duplicate tags', (tester) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: const HomeScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final mainScrollable = find.byType(Scrollable).first;
    for (final section in [
      'Trending',
      'Popular Movies',
      'Popular Series',
      'Top Rated Movies',
      'Top Rated Series',
    ]) {
      await tester.scrollUntilVisible(
        find.text(section),
        300,
        scrollable: mainScrollable,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failed home section offers an independent retry', (
    tester,
  ) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    final catalog = ControllableCatalogRepository()
      ..failures.add('trending');
    await tester.pumpWidget(withFakeCatalog(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const HomeScreen(),
        ),
      ),
      repository: catalog,
    ));
    await tester.pumpAndSettle();
    expect(find.text('No connection. Check your internet and try again.'),
        findsOneWidget);

    catalog.failures.remove('trending');
    await tester.tap(find.text('Retry').first);
    await tester.pumpAndSettle();
    expect(find.text('No connection. Check your internet and try again.'),
        findsNothing);
  });
}
