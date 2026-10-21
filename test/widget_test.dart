import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/app.dart';

import 'helpers/fake_catalog_repository.dart';

void main() {
  testWidgets('app builds with four navigation tabs', (tester) async {
    await tester.pumpWidget(
      WatchVaultApp(catalog: FakeCatalogRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

