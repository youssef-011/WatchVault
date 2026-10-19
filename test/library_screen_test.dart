import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('library shows three tabs and watched media cards', (tester) async {
    final controller = LibraryController();
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

    expect(find.text('Want to Watch'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);

    await tester.tap(find.text('Watched'));
    await tester.pumpAndSettle();

    expect(find.byType(MediaCard), findsWidgets);
  });

  testWidgets('library Add title button opens the form', (tester) async {
    final controller = LibraryController();
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

    await tester.tap(find.text('Add title'));
    await tester.pumpAndSettle();

    expect(find.text('Overview (optional)'), findsOneWidget);
  });
}
