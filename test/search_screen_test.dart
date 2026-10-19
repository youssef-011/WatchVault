import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/empty_state.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/search/presentation/search_screen.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('search filters titles and clears back to the prompt', (
    tester,
  ) async {
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const SearchScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump();
    expect(find.byType(MediaCard), findsWidgets);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Find something to watch'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nonsense');
    await tester.pump();
    expect(find.text('No results for "nonsense".'), findsOneWidget);
  });
}
