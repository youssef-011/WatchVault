import 'package:watchvault/core/models/media_type.dart';

class MediaKey {
  const MediaKey({required this.type, required this.id});

  final MediaType type;
  final int id;

  String get value => '${type.name}:$id';

  factory MediaKey.fromValue(String value) {
    final separator = value.indexOf(':');
    if (separator <= 0 || separator == value.length - 1) {
      throw FormatException('Invalid media key.', value);
    }
    try {
      final type = MediaType.values.byName(value.substring(0, separator));
      final id = int.parse(value.substring(separator + 1));
      return MediaKey(type: type, id: id);
    } on Object {
      throw FormatException('Invalid media key.', value);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaKey && other.type == type && other.id == id;

  @override
  int get hashCode => Object.hash(type, id);

  @override
  String toString() => value;
}
