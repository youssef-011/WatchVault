import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/core/models/media_key.dart';
import 'package:watchvault/core/models/media_type.dart';

import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/library_item.dart';
import '../domain/library_repository.dart';
import '../domain/watch_status.dart';

class LibraryController extends ChangeNotifier {
  LibraryController({required this.repository}) {
    _itemsView = UnmodifiableListView(_items);
  }

  final LibraryRepository repository;
  final List<LibraryItem> _items = [];
  late final List<LibraryItem> _itemsView;
  final Map<MediaType, int> _nextNegativeId = {
    MediaType.movie: -1,
    MediaType.series: -1,
  };
  final Map<MediaKey, MediaKey> _manualSnapshotKeys = {};
  LoadStatus _loadState = LoadStatus.loading;
  String? _errorMessage;

  List<LibraryItem> get items => _itemsView;
  LoadStatus get loadState => _loadState;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _loadState = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final loaded = await repository.loadItems();
      _items
        ..clear()
        ..addAll(loaded);
      _loadState = LoadStatus.ready;
      _errorMessage = null;
    } on Object {
      _loadState = LoadStatus.error;
      _errorMessage = 'Unable to load your library. Please try again.';
    }
    notifyListeners();
  }

  LibraryItem? itemFor(MediaKey key) {
    for (final item in _items) {
      if (item.key == key) return item;
    }
    return null;
  }

  bool isInLibrary(MediaKey key) => itemFor(key) != null;

  LibraryEntry? entryFor(MediaKey key) => itemFor(key)?.entry;

  List<LibraryItem> itemsByStatus(WatchStatus status) =>
      List<LibraryItem>.unmodifiable(
        _items.where((item) => item.entry.status == status),
      );

  int countFor(WatchStatus status) =>
      _items.where((item) => item.entry.status == status).length;

  double? get averageRating {
    var total = 0.0;
    var count = 0;
    for (final item in _items) {
      final entry = item.entry;
      if (entry.status == WatchStatus.watched && entry.userRating != null) {
        total += entry.userRating!;
        count++;
      }
    }
    return count == 0 ? null : total / count;
  }

  Future<void> add(
    MediaItem media, {
    WatchStatus status = WatchStatus.wantToWatch,
  }) async {
    if (isInLibrary(media.key)) return;
    final entry = LibraryEntry(
      mediaKey: media.key,
      status: status,
      addedAt: DateTime.now(),
    );
    await _saveOptimistically(LibraryItem(media: media, entry: entry));
  }

  Future<void> addTitle(AddTitleResult result) async {
    final media = result.mediaItem;
    final previousSnapshotKey = _manualSnapshotKeys[media.key];
    if (previousSnapshotKey != null && isInLibrary(previousSnapshotKey)) return;
    var id = _nextNegativeId[media.type]!;
    while (_items.any((item) => item.key == MediaKey(type: media.type, id: id))) {
      id--;
    }
    _nextNegativeId[media.type] = id - 1;
    final snapshot = media.copyWith(id: id);
    _manualSnapshotKeys[media.key] = snapshot.key;
    final sourceEntry = result.libraryEntry;
    final entry = LibraryEntry(
      mediaKey: snapshot.key,
      status: sourceEntry.status,
      userRating: sourceEntry.status == WatchStatus.watched
          ? sourceEntry.userRating
          : null,
      addedAt: sourceEntry.addedAt,
    );
    if (isInLibrary(snapshot.key)) return;
    await _saveOptimistically(LibraryItem(media: snapshot, entry: entry));
  }

  Future<void> setStatus(MediaKey key, WatchStatus status) async {
    final current = itemFor(key);
    if (current == null) return;
    final entry = LibraryEntry(
      mediaKey: current.key,
      status: status,
      userRating:
          status == WatchStatus.watched ? current.entry.userRating : null,
      addedAt: current.entry.addedAt,
    );
    await _replaceOptimistically(current, current.copyWith(entry: entry));
  }

  Future<void> setRating(MediaKey key, double? rating) async {
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
    final current = itemFor(key);
    if (current == null || current.entry.status != WatchStatus.watched) return;
    final entry = LibraryEntry(
      mediaKey: current.key,
      status: current.entry.status,
      userRating: rating,
      addedAt: current.entry.addedAt,
    );
    await _replaceOptimistically(current, current.copyWith(entry: entry));
  }

  Future<void> remove(MediaKey key) async {
    final index = _items.indexWhere((item) => item.key == key);
    if (index < 0) return;
    final oldItems = List<LibraryItem>.of(_items);
    _items.removeAt(index);
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.remove(key);
    } on Object {
      _restore(oldItems);
      _setMutationError();
    }
  }

  Future<void> _saveOptimistically(LibraryItem item) async {
    if (isInLibrary(item.key)) return;
    _items.add(item);
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.save(item);
    } on Object {
      _items.removeWhere((existing) => existing.key == item.key);
      _setMutationError();
    }
  }

  Future<void> _replaceOptimistically(
    LibraryItem oldItem,
    LibraryItem updated,
  ) async {
    final index = _items.indexOf(oldItem);
    if (index < 0) return;
    _items[index] = updated;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.save(updated);
    } on Object {
      final currentIndex = _items.indexWhere((item) => item.key == oldItem.key);
      if (currentIndex >= 0) _items[currentIndex] = oldItem;
      _setMutationError();
    }
  }

  void _restore(List<LibraryItem> oldItems) {
    _items
      ..clear()
      ..addAll(oldItems);
  }

  void _setMutationError() {
    _errorMessage = 'Unable to update your library. Please try again.';
    notifyListeners();
  }
}
