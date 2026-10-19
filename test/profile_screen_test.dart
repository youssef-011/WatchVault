import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/profile/presentation/profile_screen.dart';

void main() {
  testWidgets('profile shows stats and a coming soon snackbar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const ProfileScreen(),
      ),
    );

    expect(find.text('Want to Watch'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Coming soon'), findsOneWidget);
  });
}
