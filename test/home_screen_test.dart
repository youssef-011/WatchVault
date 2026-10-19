import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/core/widgets/media_card.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('home displays its media sections and cards', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        onGenerateRoute: AppRoutes.onGenerateRoute,
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

  testWidgets('tapping a media card opens its details screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: const HomeScreen(),
      ),
    );

    await tester.tap(find.byType(MediaCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(DetailsScreen), findsOneWidget);
  });
}
