import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/application/library_scope.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('details screen shows the title and overview section', (
    tester,
  ) async {
    final item = mockMedia.first;
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: DetailsScreen(item: item, heroTag: 'details-${item.id}'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(item.title), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
  });
}


