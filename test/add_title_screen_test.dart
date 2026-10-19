import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/router/app_routes.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/library/domain/add_title_result.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  testWidgets('empty title displays a validation error', (tester) async {
    await tester.pumpWidget(_AddTitleHarness(onResult: (_) {}));
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title'), findsOneWidget);
  });

  testWidgets('invalid year displays a validation error', (tester) async {
    await tester.pumpWidget(_AddTitleHarness(onResult: (_) {}));
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Dune');
    await tester.enterText(find.byType(TextFormField).at(1), '1887');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Enter a year from 1888'), findsOneWidget);
  });

  testWidgets('rating slider is shown only for watched status', (tester) async {
    await tester.pumpWidget(_AddTitleHarness(onResult: (_) {}));
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsNothing);
    await tester.tap(find.byType(DropdownButtonFormField<WatchStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Watched').last);
    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('valid save returns AddTitleResult from named route', (
    tester,
  ) async {
    AddTitleResult? received;
    await tester.pumpWidget(_AddTitleHarness(onResult: (value) {
      received = value;
    }));
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Arrival');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(received, isA<AddTitleResult>());
    expect(received!.mediaItem.title, 'Arrival');
    expect(received!.libraryEntry.status, WatchStatus.wantToWatch);
  });
}

class _AddTitleHarness extends StatelessWidget {
  const _AddTitleHarness({required this.onResult});

  final ValueChanged<AddTitleResult?> onResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await Navigator.of(context)
                  .pushNamed<AddTitleResult>(AppRoutes.addTitle);
              onResult(result);
            },
            child: const Text('Open form'),
          ),
        ),
      ),
    );
  }
}
