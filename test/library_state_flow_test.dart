import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';
import 'package:watchvault/features/shell/presentation/main_shell.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('added titles search, and detail status updates profile count', (
    tester,
  ) async {
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

    await tester.tap(find.text('Library').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add title'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Test Feature');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Added'), findsOneWidget);
    final addedItem = controller.catalog.last;
    expect(addedItem.title, 'Test Feature');
    expect(addedItem.id, lessThan(0));

    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test Feature');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.byType(MediaCard), findsOneWidget);
    await tester.tap(find.byType(MediaCard).first);
    await tester.pumpAndSettle();

    final watchingSegment = find.descendant(
      of: find.byType(SegmentedButton<WatchStatus>),
      matching: find.text('Watching'),
    );
    await tester.ensureVisible(watchingSegment);
    await tester.pumpAndSettle();
    await tester.tap(watchingSegment);
    await tester.pumpAndSettle();
    expect(controller.entryFor(addedItem.key)?.status, WatchStatus.watching);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
  });
}
