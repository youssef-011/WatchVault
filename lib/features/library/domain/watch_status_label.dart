import 'watch_status.dart';

extension WatchStatusLabel on WatchStatus {
  String get label => switch (this) {
        WatchStatus.wantToWatch => 'Want to Watch',
        WatchStatus.watching => 'Watching',
        WatchStatus.watched => 'Watched',
      };
}
