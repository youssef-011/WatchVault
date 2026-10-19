import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/library_repository.dart';
import '../domain/media_item.dart';
import '../domain/watch_status.dart';

enum LibraryLoadState { loading, ready, error }

class LibraryController extends ChangeNotifier {
  LibraryController({required this.repository}) {
    _catalogView = UnmodifiableListView(_catalog);
    _entriesView = UnmodifiableListView(_entries);
  }

  final LibraryRepository repository;
  final List<MediaItem> _catalog = [];
  final List<LibraryEntry> _entries = [];
  late final List<MediaItem> _catalogView;
  late final List<LibraryEntry> _entriesView;
  LibraryLoadState _loadState = LibraryLoadState.loading;
  String? _errorMessage;
  int _nextNegativeId = -1;

  List<MediaItem> get catalog => _catalogView;
  List<LibraryEntry> get entries => _entriesView;
  LibraryLoadState get loadState => _loadState;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _loadState = LibraryLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final catalog = await repository.loadCatalog();
      final entries = await repository.loadEntries();
      _catalog
        ..clear()
        ..addAll(catalog);
      _entries
        ..clear()
        ..addAll(entries);
      _loadState = LibraryLoadState.ready;
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _loadState = LibraryLoadState.error;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  List<LibraryEntry> entriesByStatus(WatchStatus status) =>
      List<LibraryEntry>.unmodifiable(
        _entries.where((entry) => entry.status == status),
      );

  MediaItem? mediaById(int id) {
    for (final item in _catalog) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  LibraryEntry? entryFor(int mediaId) {
    for (final entry in _entries) {
      if (entry.mediaId == mediaId) {
        return entry;
      }
    }
    return null;
  }

  int countFor(WatchStatus status) =>
      _entries.where((entry) => entry.status == status).length;

  double? get averageRating {
    var total = 0.0;
    var count = 0;
    for (final entry in _entries) {
      if (entry.status == WatchStatus.watched && entry.userRating != null) {
        total += entry.userRating!;
        count++;
      }
    }
    return count == 0 ? null : total / count;
  }

  Future<void> addTitle(AddTitleResult result) async {
    final oldCatalog = List<MediaItem>.of(_catalog);
    final oldEntries = List<LibraryEntry>.of(_entries);
    while (_catalog.any((item) => item.id == _nextNegativeId)) {
      _nextNegativeId--;
    }
    final id = _nextNegativeId--;
    final item = result.mediaItem.copyWith(id: id);
    final entry = LibraryEntry(
      mediaId: id,
      status: result.libraryEntry.status,
      userRating: result.libraryEntry.status == WatchStatus.watched
          ? result.libraryEntry.userRating
          : null,
      addedAt: result.libraryEntry.addedAt,
    );
    _errorMessage = null;
    _catalog.add(item);
    _entries.add(entry);
    notifyListeners();

    try {
      await repository.saveEntry(entry, newMedia: item);
    } catch (error) {
      _restore(oldCatalog, oldEntries);
      _setMutationError(error);
    }
  }

  Future<void> addExistingMedia(
    int mediaId, {
    WatchStatus status = WatchStatus.wantToWatch,
  }) async {
    final item = mediaById(mediaId);
    if (item == null || entryFor(mediaId) != null) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final entry = LibraryEntry(
      mediaId: mediaId,
      status: status,
      addedAt: DateTime.now(),
    );
    _errorMessage = null;
    _entries.add(entry);
    notifyListeners();

    try {
      await repository.saveEntry(entry);
    } catch (error) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError(error);
    }
  }

  Future<void> setStatus(int mediaId, WatchStatus status) async {
    final index = _entries.indexWhere((entry) => entry.mediaId == mediaId);
    if (index < 0) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final current = _entries[index];
    final updated = LibraryEntry(
      mediaId: current.mediaId,
      status: status,
      userRating: status == WatchStatus.watched ? current.userRating : null,
      addedAt: current.addedAt,
    );
    _errorMessage = null;
    _entries[index] = updated;
    notifyListeners();

    try {
      await repository.saveEntry(updated);
    } catch (error) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError(error);
    }
  }

  Future<void> setRating(int mediaId, double? rating) async {
    if (rating != null &&
        (!rating.isFinite ||
            rating < 0.5 ||
            rating > 5.0 ||
            rating * 2 != (rating * 2).round())) {
      throw ArgumentError.value(
        rating,
        'rating',
        'Must be null or a half-step from 0.5 to 5.0.',
      );
    }

    final index = _entries.indexWhere((entry) => entry.mediaId == mediaId);
    if (index < 0 || _entries[index].status != WatchStatus.watched) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final current = _entries[index];
    final updated = LibraryEntry(
      mediaId: current.mediaId,
      status: current.status,
      userRating: rating,
      addedAt: current.addedAt,
    );
    _errorMessage = null;
    _entries[index] = updated;
    notifyListeners();

    try {
      await repository.saveEntry(updated);
    } catch (error) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError(error);
    }
  }

  Future<void> removeEntry(int mediaId) async {
    final index = _entries.indexWhere((entry) => entry.mediaId == mediaId);
    if (index < 0) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    _errorMessage = null;
    _entries.removeAt(index);
    notifyListeners();

    try {
      await repository.removeEntry(mediaId);
    } catch (error) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError(error);
    }
  }

  void _restore(List<MediaItem> catalog, List<LibraryEntry> entries) {
    _catalog
      ..clear()
      ..addAll(catalog);
    _entries
      ..clear()
      ..addAll(entries);
  }

  void _setMutationError(Object error) {
    _errorMessage = error.toString();
    notifyListeners();
  }
}
