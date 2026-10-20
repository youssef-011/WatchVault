import 'package:flutter/foundation.dart';
import 'package:watchvault/core/models/load_status.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/data/catalog_exception.dart';
import 'package:watchvault/features/catalog/domain/catalog_repository.dart';
import 'package:watchvault/features/catalog/domain/media_details.dart';
import 'package:watchvault/features/catalog/presentation/catalog_exception_message.dart';

class DetailsController extends ChangeNotifier {
  DetailsController({required this.catalog, required this.item});

  final CatalogRepository catalog;
  final MediaItem item;
  LoadStatus _status = LoadStatus.loading;
  LoadStatus get status => _status;
  MediaDetails? _details;
  MediaDetails? get details => _details;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _disposed = false;

  Future<void> load() async {
    if (item.id < 0) {
      _status = LoadStatus.ready;
      _errorMessage = null;
      notifyListeners();
      return;
    }
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _details = await catalog.details(item.key);
      _status = LoadStatus.ready;
    } on Object catch (error) {
      _status = LoadStatus.error;
      _errorMessage = error is CatalogException
          ? error.userMessage
          : 'Something went wrong. Try again.';
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
