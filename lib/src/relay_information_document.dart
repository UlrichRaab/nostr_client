import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'relay_information_document.g.dart';

/// A document which contains server metadata of a relay. This includes
/// capabilities, administrative contacts, and various other server attributes.
@sealed
@immutable
@JsonSerializable()
class RelayInformationDocument {
  const RelayInformationDocument({
    this.name,
    this.description,
    this.pubkey,
    this.contact,
    this.supportedNips,
    this.software,
    this.version,
  });

  factory RelayInformationDocument.fromJson(Map<String, dynamic> json) {
    return _$RelayInformationDocumentFromJson(json);
  }

  factory RelayInformationDocument.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return RelayInformationDocument.fromJson(json);
  }

  /// The display name of the relay.
  final String? name;

  /// Detailed plain-text information about the relay.
  final String? description;

  /// The public key of the administrative contact.
  final String? pubkey;

  /// The administrative alternate contact.
  final String? contact;

  /// The list of NIP numbers supported by the relay.
  final List<int>? supportedNips;

  /// A string identifying the relay software URL.
  final String? software;

  /// The version of the software.
  final String? version;

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
      name,
      description,
      pubkey,
      contact,
      Object.hashAll(supportedNips ?? []),
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
