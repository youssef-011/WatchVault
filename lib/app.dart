import 'dart:async';

import 'package:flutter/material.dart';

import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/application/catalog_scope.dart';
import 'features/catalog/data/tmdb_catalog_repository.dart';
import 'features/catalog/data/tmdb_client.dart';
import 'features/catalog/domain/catalog_repository.dart';
import 'features/library/application/library_controller.dart';
import 'features/library/application/library_scope.dart';
import 'features/library/data/in_memory_library_repository.dart';
import 'features/library/domain/library_repository.dart';
import 'features/shell/presentation/main_shell.dart';

class WatchVaultApp extends StatefulWidget {
  const WatchVaultApp({super.key, this.catalog, this.libraryRepository});

  final CatalogRepository? catalog;
  final LibraryRepository? libraryRepository;

  @override
  State<WatchVaultApp> createState() => _WatchVaultAppState();
}

class _WatchVaultAppState extends State<WatchVaultApp> {
  late final LibraryRepository _repository;
  late final LibraryController _libraryController;
  late final CatalogRepository _catalog;

  @override
  void initState() {
    super.initState();
    _repository = widget.libraryRepository ?? InMemoryLibraryRepository();
    _catalog = widget.catalog ?? TmdbCatalogRepository(client: TmdbClient());
    _libraryController = LibraryController(repository: _repository);
    unawaited(_libraryController.load());
  }

  @override
  void dispose() {
    _libraryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CatalogScope(
      repository: _catalog,
      child: LibraryScope(
        controller: _libraryController,
        child: MaterialApp(
          title: 'WatchVault',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: const MainShell(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    );
  }
}
