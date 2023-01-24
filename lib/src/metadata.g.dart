// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
      rawData: json['raw_data'] as Map<String, dynamic>,
      name: json['name'] as String?,
      about: json['about'] as String?,
      picture: json['picture'] as String?,
      nip05: json['nip05'] == null
          ? null
          : Nip05.fromJson(json['nip05'] as Map<String, dynamic>),
    );
