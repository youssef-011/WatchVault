import 'package:flutter/widgets.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';

class CatalogScope extends InheritedWidget {
  const CatalogScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final CatalogRepository repository;

  static CatalogRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CatalogScope>();
    assert(scope != null, 'CatalogScope is missing above this context.');
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(CatalogScope oldWidget) =>
      repository != oldWidget.repository;
}
