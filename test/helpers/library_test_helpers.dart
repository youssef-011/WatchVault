import 'package:watchvault/features/library/application/library_controller.dart';
import 'package:watchvault/features/library/data/in_memory_library_repository.dart';

Future<LibraryController> createLoadedLibraryController() async {
  final controller = LibraryController(
    repository: InMemoryLibraryRepository(),
  );
  await controller.load();
  return controller;
}
