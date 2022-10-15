import 'package:meta/meta.dart';

@sealed
@immutable
class Event {
  const Event({
    required this.id,
    required this.pubkey,
    required this.createdAt,
    required this.kind,
    required this.tags,
    required this.content,
    required this.sig,
  });

  /// 32-bytes sha256 of the the serialized event data.
  final String id;

  /// 32-bytes hex-encoded public key of the event creator.
  final String pubkey;

  /// Unix timestamp in seconds.
  final int createdAt;

  /// The kind of event.
  final int kind;

  ///
  final List<List<String>> tags;

  /// Arbitrary string.
  final String content;

  /// 64-bytes signature of the sha256 hash of the serialized event data, which
  /// is the same as the **id** field.
  final String sig;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    final sb = StringBuffer()..write('Event');
    return sb.toString();
  }
}
