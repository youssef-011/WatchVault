import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/app.dart';

void main() {
  testWidgets('app builds with four navigation tabs', (tester) async {
    await tester.pumpWidget(const WatchVaultApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

