import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/details/presentation/details_screen.dart';
import 'package:watchvault/features/home/data/mock_media.dart';

void main() {
  testWidgets('details screen shows the title and overview section', (
    tester,
  ) async {
    final item = mockMedia.first;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: DetailsScreen(item: item),
      ),
    );

    expect(find.text(item.title), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
  });
}


