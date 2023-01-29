// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nip05.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nip05 _$Nip05FromJson(Map<String, dynamic> json) => Nip05(
      verified: json['verified'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );

Map<String, dynamic> _$Nip05ToJson(Nip05 instance) {
  final val = <String, dynamic>{
    'verified': instance.verified,
    'name': instance.name,
    'domain': instance.domain,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('verified_at', instance.verifiedAt?.toIso8601String());
  return val;
}
