import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'event.g.dart';

@sealed
@immutable
@JsonSerializable()
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return _$EventFromJson(json);
  }

  factory Event.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Event.fromJson(json);
  }

  /// 32-bytes sha256 of the the serialized event data.
  final String id;

  /// 32-bytes hex-encoded public key of the event creator.
  final String pubkey;

  /// The creation timestamp of the event.
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// The kind of event.
  final int kind;

  ///
  final List<List<String>> tags;

  /// Arbitrary string.
  final String content;

  /// 64-bytes signature of the sha256 hash of the serialized event data, which
  /// is the same as the **id** field.
  final String sig;

  /// Converts this event to json.
  Map<String, dynamic> toJson() {
    return _$EventToJson(this);
  }

  /// Converts this event to a json string.
  String toJsonString({bool pretty = false}) {
    final json = toJson();
    final encoder = pretty ? JsonEncoder.withIndent(' ' * 2) : JsonEncoder();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Event &&
        other.id == id &&
        other.pubkey == pubkey &&
        other.createdAt == createdAt &&
        other.kind == kind &&
        ListEquality(ListEquality()).equals(other.tags, tags) &&
        other.content == content &&
        other.sig == sig;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      pubkey,
      createdAt,
      kind,
      Object.hashAll(tags.map((e) => Object.hashAll(e))),
      content,
      sig,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'Event $jsonString';
  }
}

// Internal

DateTime _dateTimeFromJson(int json) {
  return DateTime.fromMillisecondsSinceEpoch(json * 1000);
}

int _dateTimeToJson(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}
