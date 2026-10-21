import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/catalog/presentation/catalog_exception_message.dart';

enum SearchResultsStatus { idle, loading, ready, error }

class SearchResultsController extends ChangeNotifier {
  SearchResultsController({
    required this.catalog,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  final CatalogRepository catalog;
  final Duration debounceDuration;
  Timer? _timer;
  String _query = '';
  List<MediaItem> _results = const [];
  SearchResultsStatus _status = SearchResultsStatus.idle;
  String? _errorMessage;
  int _requestToken = 0;

  String get query => _query;
  List<MediaItem> get results => _results;
  SearchResultsStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void setQuery(String query) {
    _query = query.trim();
    _requestToken++;
    _timer?.cancel();
    _results = const [];
    _errorMessage = null;
    if (_query.length < 2) {
      _status = SearchResultsStatus.idle;
      notifyListeners();
      return;
    }
    _status = SearchResultsStatus.loading;
    notifyListeners();
    final token = _requestToken;
    _timer = Timer(debounceDuration, () => unawaited(_search(token)));
  }

  Future<void> retry() async {
    _timer?.cancel();
    if (_query.length < 2) return;
    _requestToken++;
    _status = SearchResultsStatus.loading;
    _errorMessage = null;
    notifyListeners();
    await _search(_requestToken);
  }

  Future<void> _search(int token) async {
    try {
      final catalogResults = await catalog.search(_query);
      if (token != _requestToken || isDisposed) return;
      _results = List<MediaItem>.unmodifiable(catalogResults);
      _status = SearchResultsStatus.ready;
      _errorMessage = null;
    } on Object catch (error) {
      if (token != _requestToken || isDisposed) return;
      _status = SearchResultsStatus.error;
      _errorMessage = error is CatalogException
          ? error.userMessage
          : 'Something went wrong. Try again.';
    }
    if (!isDisposed) notifyListeners();
  }

  bool _disposed = false;
  bool get isDisposed => _disposed;

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
