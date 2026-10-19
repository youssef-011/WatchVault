import 'package:flutter/widgets.dart';

import 'library_controller.dart';

class LibraryScope extends InheritedNotifier<LibraryController> {
  const LibraryScope({
    super.key,
    required LibraryController controller,
    required super.child,
  }) : super(notifier: controller);

  static LibraryController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LibraryScope>();
    final controller = scope?.notifier;
    if (controller == null) {
      throw FlutterError('LibraryScope is missing above this context.');
    }
    return controller;
  }
}
