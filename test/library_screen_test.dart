import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('library shows three tabs and watched media cards', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const LibraryScreen(),
      ),
    );

    expect(find.text('Want to Watch'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);

    await tester.tap(find.text('Watched'));
    await tester.pumpAndSettle();

    expect(find.byType(MediaCard), findsWidgets);
  });
}
