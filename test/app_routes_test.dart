import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/data/mock_media.dart';
import 'package:watchvault/features/library/application/library_scope.dart';

import 'helpers/library_test_helpers.dart';

void main() {
  testWidgets('unknown named route shows NotFoundScreen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/unknown'),
              child: const Text('Open unknown'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open unknown'));
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundScreen), findsOneWidget);
  });

  testWidgets('details route with wrong arguments shows NotFoundScreen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.details,
                arguments: 'not a media item',
              ),
              child: const Text('Open invalid details'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open invalid details'));
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundScreen), findsOneWidget);
  });

  testWidgets('details route passes its MediaItem argument', (tester) async {
    final item = mockMedia.first;
    final controller = await createLoadedLibraryController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      LibraryScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.details,
                  arguments: item,
                ),
                child: const Text('Open details'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open details'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailsScreen), findsOneWidget);
    expect(find.text(item.title), findsWidgets);
  });
}
