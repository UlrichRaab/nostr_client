import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:nostr_client/src/nip05.dart';

import 'event.dart';
import 'event_kind.dart';

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

  static Future<Metadata> withCheckedNip05(Event event) async {
    if (event.kind != EventKind.metadata) {
      throw ArgumentError('Event is not a metadata event.');
    }

    final json = jsonDecode(event.content);

    if (!json.containsKey('nip05')) {
      return Metadata.fromJson(json);
    }

    final n05 = await Nip05.verifyNip05(event.pubkey, json['nip05']);

    return Metadata(
      rawData: json as Map<String, dynamic>,
      name: json['display_name'] as String?,
      about: json['about'] as String?,
      picture: json['picture'] as String?,
      nip05: json['nip05'] = n05,
    );
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
