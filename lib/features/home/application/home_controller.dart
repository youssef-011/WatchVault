import 'package:flutter/foundation.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/catalog/presentation/catalog_exception_message.dart';

enum HomeSection {
  trending,
  popularMovies,
  popularSeries,
  topRatedMovies,
  topRatedSeries,
}

class HomeSectionState {
  const HomeSectionState({
    this.status = LoadStatus.loading,
    this.items = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<MediaItem> items;
  final String? errorMessage;
}

class HomeController extends ChangeNotifier {
  HomeController({required this.catalog}) {
    _sections = {
      for (final section in HomeSection.values)
        section: const HomeSectionState(),
    };
  }

  final CatalogRepository catalog;
  late final Map<HomeSection, HomeSectionState> _sections;
  bool _hasLoaded = false;

  HomeSectionState section(HomeSection section) => _sections[section]!;

  Future<void> loadAll() async {
    _hasLoaded = true;
    await Future.wait(HomeSection.values.map(loadSection));
  }

  Future<void> loadIfNeeded() async {
    if (!_hasLoaded) await loadAll();
  }

  Future<void> loadSection(HomeSection section) async {
    _sections[section] = const HomeSectionState(status: LoadStatus.loading);
    notifyListeners();
    try {
      final items = await switch (section) {
        HomeSection.trending => catalog.trending(),
        HomeSection.popularMovies => catalog.popularMovies(),
        HomeSection.popularSeries => catalog.popularSeries(),
        HomeSection.topRatedMovies => catalog.topRatedMovies(),
        HomeSection.topRatedSeries => catalog.topRatedSeries(),
      };
      _sections[section] = HomeSectionState(
        status: LoadStatus.ready,
        items: List<MediaItem>.unmodifiable(items),
      );
    } on Object catch (error) {
      _sections[section] = HomeSectionState(
        status: LoadStatus.error,
        errorMessage: error is CatalogException
            ? error.userMessage
            : 'Something went wrong. Try again.',
      );
    }
    notifyListeners();
  }
}
