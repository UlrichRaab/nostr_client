import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'relay_information_document.g.dart';

/// A filter determines what events will be sent in a subscription.
@sealed
@immutable
@JsonSerializable()
class RelayInformationDocument {
  const RelayInformationDocument({
    this.id,
    required this.name,
    required this.description,
    required this.pubkey,
    this.contact,
    required this.supportedNips,
    required this.software,
    required this.version,
  });

  factory RelayInformationDocument.fromJson(Map<String, dynamic> json) {
    return _$RelayInformationDocumentFromJson(json);
  }

  factory RelayInformationDocument.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return RelayInformationDocument.fromJson(json);
  }

  final String? id;
  final String name;
  final String description;
  final String pubkey;
  final String? contact;
  final List<int> supportedNips;
  final String software;
  final String version;

  /// Converts this relay information document to json.
  Map<String, dynamic> toJson() {
    return _$RelayInformationDocumentToJson(this);
  }

  /// Converts this relay information document to a json string.
  String toJsonString({bool pretty = false}) {
    final json = toJson();
    final encoder = pretty ? JsonEncoder.withIndent(' ' * 2) : JsonEncoder();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelayInformationDocument &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.pubkey == pubkey &&
        other.contact == contact &&
        ListEquality().equals(other.supportedNips, supportedNips) &&
        other.software == software &&
        other.version == version;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      pubkey,
      contact,
      Object.hashAll(supportedNips),
      software,
      version,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'RelayInformationDocument $jsonString';
  }
}
