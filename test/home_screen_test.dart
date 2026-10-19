import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('home displays its media sections and cards', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );

    final mainScrollable = find.byType(Scrollable).first;
    for (final title in ['Trending', 'Popular Series', 'Top Rated']) {
      await tester.scrollUntilVisible(
        find.text(title),
        300,
        scrollable: mainScrollable,
      );
      expect(find.text(title), findsOneWidget);
    }

    expect(find.byType(MediaCard), findsWidgets);
  });
}
