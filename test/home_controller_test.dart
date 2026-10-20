import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/features/home/application/home_controller.dart';

import 'helpers/controllable_catalog_repository.dart';

void main() {
  test('home sections load independently and a failed section can retry', () async {
    final repository = ControllableCatalogRepository()
      ..failures.add('trending');
    final controller = HomeController(catalog: repository);
    addTearDown(controller.dispose);

    await controller.loadAll();

    expect(controller.section(HomeSection.trending).status, LoadStatus.error);
    expect(controller.section(HomeSection.popularMovies).status, LoadStatus.ready);
    repository.failures.remove('trending');
    await controller.loadSection(HomeSection.trending);
    expect(controller.section(HomeSection.trending).status, LoadStatus.ready);
  });
}
