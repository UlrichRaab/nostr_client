// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMetadata _$UserMetadataFromJson(Map<String, dynamic> json) => UserMetadata(
      rawData: json['raw_data'] as Map<String, dynamic>,
      name: json['name'] as String?,
      about: json['about'] as String?,
      picture: json['picture'] as String?,
    );

Map<String, dynamic> _$UserMetadataToJson(UserMetadata instance) {
  final val = <String, dynamic>{
    'raw_data': instance.rawData,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('about', instance.about);
  writeNotNull('picture', instance.picture);
  return val;
}
