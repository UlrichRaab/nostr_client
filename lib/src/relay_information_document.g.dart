// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relay_information_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelayInformationDocument _$RelayInformationDocumentFromJson(
        Map<String, dynamic> json) =>
    RelayInformationDocument(
      name: json['name'] as String,
      description: json['description'] as String,
      pubkey: json['pubkey'] as String,
      contact: json['contact'] as String?,
      supportedNips: (json['supported_nips'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      software: json['software'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$RelayInformationDocumentToJson(
    RelayInformationDocument instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  val['name'] = instance.name;
  val['description'] = instance.description;
  val['pubkey'] = instance.pubkey;
  writeNotNull('contact', instance.contact);
  val['supported_nips'] = instance.supportedNips;
  val['software'] = instance.software;
  val['version'] = instance.version;
  return val;
}
