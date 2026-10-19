import 'package:flutter_test/flutter_test.dart';
import 'package:watchvault/features/library/domain/library_entry.dart';
import 'package:watchvault/features/library/domain/watch_status.dart';

void main() {
  test('toMap and fromMap preserve a library entry', () {
    final entry = LibraryEntry(
      mediaId: 42,
      status: WatchStatus.watching,
      userRating: 4.5,
      addedAt: DateTime.utc(2025, 3, 12, 14, 30),
    );

    expect(LibraryEntry.fromMap(entry.toMap()), entry);
  });
}
