import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../home/data/mock_media.dart';
import '../data/mock_library.dart';
import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/media_item.dart';
import '../domain/watch_status.dart';

class LibraryController extends ChangeNotifier {
  LibraryController({
    Iterable<MediaItem>? catalog,
    Iterable<LibraryEntry>? entries,
  })  : _catalog = List<MediaItem>.of(catalog ?? mockMedia),
        _entries = List<LibraryEntry>.of(entries ?? mockLibrary) {
    _catalogView = UnmodifiableListView(_catalog);
    _entriesView = UnmodifiableListView(_entries);
  }

  final List<MediaItem> _catalog;
  final List<LibraryEntry> _entries;
  late final List<MediaItem> _catalogView;
  late final List<LibraryEntry> _entriesView;
  int _nextNegativeId = -1;

  List<MediaItem> get catalog => _catalogView;
  List<LibraryEntry> get entries => _entriesView;

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

  MediaItem addTitle(AddTitleResult result) {
    while (_catalog.any((item) => item.id == _nextNegativeId)) {
      _nextNegativeId--;
    }
    final id = _nextNegativeId--;
    final item = result.mediaItem.copyWith(id: id);
    _catalog.add(item);
    _entries.add(
      LibraryEntry(
        mediaId: id,
        status: result.libraryEntry.status,
        userRating: result.libraryEntry.status == WatchStatus.watched
            ? result.libraryEntry.userRating
            : null,
        addedAt: result.libraryEntry.addedAt,
      ),
    );
    notifyListeners();
    return item;
  }

  void addExistingMedia(
    int mediaId, {
    WatchStatus status = WatchStatus.wantToWatch,
  }) {
    if (mediaById(mediaId) != null && entryFor(mediaId) == null) {
      _entries.add(
        LibraryEntry(
          mediaId: mediaId,
          status: status,
          addedAt: DateTime.now(),
        ),
      );
    }
    notifyListeners();
  }

  void setStatus(int mediaId, WatchStatus status) {
    final index = _entries.indexWhere((entry) => entry.mediaId == mediaId);
    if (index >= 0) {
      final current = _entries[index];
      _entries[index] = LibraryEntry(
        mediaId: current.mediaId,
        status: status,
        userRating: status == WatchStatus.watched ? current.userRating : null,
        addedAt: current.addedAt,
      );
    }
    notifyListeners();
  }

  void setRating(int mediaId, double? rating) {
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
    if (index >= 0 && _entries[index].status == WatchStatus.watched) {
      final current = _entries[index];
      _entries[index] = LibraryEntry(
        mediaId: current.mediaId,
        status: current.status,
        userRating: rating,
        addedAt: current.addedAt,
      );
    }
    notifyListeners();
  }

  void removeEntry(int mediaId) {
    _entries.removeWhere((entry) => entry.mediaId == mediaId);
    notifyListeners();
  }
}
