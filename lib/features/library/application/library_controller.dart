import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';

import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/library_repository.dart';
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
    } catch (_) {
      _loadState = LibraryLoadState.error;
      _errorMessage = 'Unable to load your library. Please try again.';
      notifyListeners();
    }
  }

  List<LibraryEntry> entriesByStatus(WatchStatus status) =>
      List<LibraryEntry>.unmodifiable(
        _entries.where((entry) => entry.status == status),
      );

  MediaItem? mediaByKey(MediaKey key) {
    for (final item in _catalog) {
      if (item.key == key) {
        return item;
      }
    }
    return null;
  }

  LibraryEntry? entryFor(MediaKey mediaKey) {
    for (final entry in _entries) {
      if (entry.mediaKey == mediaKey) {
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
      mediaKey: item.key,
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
    } catch (_) {
      _restore(oldCatalog, oldEntries);
      _setMutationError();
    }
  }

  Future<void> addExistingMedia(
    MediaKey mediaKey, {
    WatchStatus status = WatchStatus.wantToWatch,
  }) async {
    final item = mediaByKey(mediaKey);
    if (item == null || entryFor(mediaKey) != null) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final entry = LibraryEntry(
      mediaKey: mediaKey,
      status: status,
      addedAt: DateTime.now(),
    );
    _errorMessage = null;
    _entries.add(entry);
    notifyListeners();

    try {
      await repository.saveEntry(entry);
    } catch (_) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError();
    }
  }

  Future<void> setStatus(MediaKey mediaKey, WatchStatus status) async {
    final index = _entries.indexWhere((entry) => entry.mediaKey == mediaKey);
    if (index < 0) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final current = _entries[index];
    final updated = LibraryEntry(
      mediaKey: current.mediaKey,
      status: status,
      userRating: status == WatchStatus.watched ? current.userRating : null,
      addedAt: current.addedAt,
    );
    _errorMessage = null;
    _entries[index] = updated;
    notifyListeners();

    try {
      await repository.saveEntry(updated);
    } catch (_) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError();
    }
  }

  Future<void> setRating(MediaKey mediaKey, double? rating) async {
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

    final index = _entries.indexWhere((entry) => entry.mediaKey == mediaKey);
    if (index < 0 || _entries[index].status != WatchStatus.watched) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final oldEntries = List<LibraryEntry>.of(_entries);
    final current = _entries[index];
    final updated = LibraryEntry(
      mediaKey: current.mediaKey,
      status: current.status,
      userRating: rating,
      addedAt: current.addedAt,
    );
    _errorMessage = null;
    _entries[index] = updated;
    notifyListeners();

    try {
      await repository.saveEntry(updated);
    } catch (_) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError();
    }
  }

  Future<void> removeEntry(MediaKey mediaKey) async {
    final index = _entries.indexWhere((entry) => entry.mediaKey == mediaKey);
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
      await repository.removeEntry(mediaKey);
    } catch (_) {
      _entries
        ..clear()
        ..addAll(oldEntries);
      _setMutationError();
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

  void _setMutationError() {
    _errorMessage = 'Unable to update your library. Please try again.';
    notifyListeners();
  }
}
