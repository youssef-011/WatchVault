import 'package:flutter/widgets.dart';
import 'package:watchvault/features/catalog/application/catalog_scope.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';
import 'package:watchvault/features/library/domain/library_item.dart';

import 'fake_catalog_repository.dart';

Future<LibraryController> createLoadedLibraryController({
  Iterable<LibraryItem> initial = const [],
}) async {
  final controller = LibraryController(
    repository: InMemoryLibraryRepository(initial: initial),
  );
  await controller.load();
  return controller;
}

Widget withFakeCatalog(
  Widget child, {
  CatalogRepository? repository,
}) =>
    CatalogScope(
      repository: repository ?? FakeCatalogRepository(),
      child: child,
    );
