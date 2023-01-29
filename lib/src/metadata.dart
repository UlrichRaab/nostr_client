import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:nostr_client/src/nip05.dart';

part 'metadata.g.dart';

@sealed
@immutable
@JsonSerializable(createToJson: false)
class Metadata {
  const Metadata({
    required this.rawData,
    this.name,
    this.about,
    this.picture,
    this.nip05,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    final json2 = Map.of(json);
    json2['raw_data'] = json;
    return _$MetadataFromJson(json2);
  }

  factory Metadata.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Metadata.fromJson(json);
  }

  /// The raw user metadata as key-value pairs.
  final Map<String, dynamic> rawData;

  /// The name of the user.
  final String? name;

  /// The bio of the user.
  final String? about;

  /// The URL of the profile pcture of the user.
  final String? picture;

  /// The internet identifier of the user.
  final Nip05? nip05;

  /// Converts this user metadata to json.
  Map<String, dynamic> toJson() {
    return Map.of(rawData);
  }

  /// Converts this user metadata to a json string.
  String toJsonString({bool pretty = false}) {
    final json = toJson();
    final encoder = pretty ? JsonEncoder.withIndent(' ' * 2) : JsonEncoder();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Metadata && MapEquality().equals(other.rawData, rawData);
  }

  @override
  int get hashCode {
    // This only works if the map does not contain other collections.
    return MapEquality().hash(rawData);
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'Metadata $jsonString';
  }
}
