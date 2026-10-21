import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';
import 'package:watchvault/features/shell/presentation/main_shell.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets(
    'Search title adds to Library, updates status and rating, then removes',
    (tester) async {
      final controller = await createLoadedLibraryController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(withFakeCatalog(
        LibraryScope(
          controller: controller,
          child: MaterialApp(
            theme: AppTheme.dark,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            home: const MainShell(),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'dune');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MediaCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(DetailsScreen), findsOneWidget);
      expect(controller.items, isEmpty);
      final addButton = find.text('Add to library');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('Added'), findsOneWidget);
      expect(controller.countFor(WatchStatus.wantToWatch), 1);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Library').last);
      await tester.pumpAndSettle();
      expect(find.byType(MediaCard), findsOneWidget);

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MediaCard).first);
      await tester.pumpAndSettle();

      final watched = find.descendant(
        of: find.byType(SegmentedButton<WatchStatus>),
        matching: find.text('Watched'),
      );
      await tester.ensureVisible(watched);
      await tester.pumpAndSettle();
      await tester.tap(watched);
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(4.5);
      await tester.pumpAndSettle();
      expect(controller.averageRating, 4.5);
      expect(controller.countFor(WatchStatus.watched), 1);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile').last);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MediaCard).first);
      await tester.pumpAndSettle();

      final removeButton = find.text('Remove from library');
      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();
      await tester.tap(removeButton);
      await tester.pumpAndSettle();
      expect(find.text('Removed from library'), findsOneWidget);
      expect(controller.items, isEmpty);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile').last);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsWidgets);
      expect(find.text('—'), findsOneWidget);
    },
  );
}
