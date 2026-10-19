import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/theme/app_theme.dart';
import 'package:watchvault/features/home/presentation/home_screen.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/application/library_scope.dart';
import 'package:watchvault/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('home and library fit phone and tablet layouts at larger text', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = LibraryController();
    addTearDown(controller.dispose);
    tester.view.devicePixelRatio = 1;

    for (final size in [const Size(320, 640), const Size(1000, 700)]) {
      tester.view.physicalSize = size;
      for (final screen in [const HomeScreen(), const LibraryScreen()]) {
        await tester.pumpWidget(
          LibraryScope(
            controller: controller,
            child: MaterialApp(
              theme: AppTheme.dark,
              home: Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(1.3),
                  ),
                  child: screen,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    }
  });
}
