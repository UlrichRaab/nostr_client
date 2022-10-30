import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'filter.g.dart';

/// A filter determines what events will be sent in a subscription.
@sealed
@immutable
@JsonSerializable()
class Filter {
  const Filter({
    this.ids,
    this.authors,
    this.kinds,
    this.e,
    this.p,
    this.since,
    this.until,
    this.limit,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return _$FilterFromJson(json);
  }

  factory Filter.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Filter.fromJson(json);
  }

  /// A list of event ids or prefixes.
  final List<String>? ids;

  /// A list of pubkeys or prefixes, the pubkey of an event must be one of
  /// these.
  final List<String>? authors;

  /// A list of a kind numbers.
  final List<int>? kinds;

  /// A list of event ids that are referenced in an **e** tag.
  @JsonKey(name: '#e')
  final List<String>? e;

  /// A list of pubkeys that are referenced in a **p** tag.
  @JsonKey(name: '#p')
  final List<String>? p;

  /// A timestamp, events must be newer than this to pass.
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? since;

  /// A timestamp, events must be older than this to pass.
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? until;

  /// Maximum number of events to be returned in the initial query.
  final int? limit;

  /// Converts this filter to json.
  Map<String, dynamic> toJson() {
    return _$FilterToJson(this);
  }

  /// Converts this filter to a json string.
  String toJsonString() {
    final json = toJson();
    return jsonEncode(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Filter &&
        ListEquality().equals(other.ids, ids) &&
        ListEquality().equals(other.authors, authors) &&
        ListEquality().equals(other.kinds, kinds) &&
        ListEquality().equals(other.e, e) &&
        ListEquality().equals(other.p, p) &&
        other.since == since &&
        other.until == until &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return Object.hash(
      ids != null ? Object.hashAll(ids!) : null,
      authors != null ? Object.hashAll(authors!) : null,
      kinds != null ? Object.hashAll(kinds!) : null,
      e != null ? Object.hashAll(e!) : null,
      p != null ? Object.hashAll(p!) : null,
      since,
      until,
      limit,
    );
  }
}

// Internal

DateTime? _dateTimeFromJson(int? json) {
  if (json == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(json * 1000);
}

int? _dateTimeToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}
