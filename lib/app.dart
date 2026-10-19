import 'dart:async';

import 'package:flutter/material.dart';

import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/library/application/library_controller.dart';
import 'features/library/application/library_scope.dart';
import 'features/library/data/in_memory_library_repository.dart';
import 'features/shell/presentation/main_shell.dart';

class WatchVaultApp extends StatefulWidget {
  const WatchVaultApp({super.key});

  @override
  State<WatchVaultApp> createState() => _WatchVaultAppState();
}

class _WatchVaultAppState extends State<WatchVaultApp> {
  late final InMemoryLibraryRepository _repository;
  late final LibraryController _libraryController;

  @override
  void initState() {
    super.initState();
    _repository = InMemoryLibraryRepository();
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
    return LibraryScope(
      controller: _libraryController,
      child: MaterialApp(
        title: 'WatchVault',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const MainShell(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
