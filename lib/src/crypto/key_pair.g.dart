// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyPair _$KeyPairFromJson(Map<String, dynamic> json) => KeyPair(
      publicKey: json['public_key'] as String,
      privateKey: json['private_key'] as String,
    );

Map<String, dynamic> _$KeyPairToJson(KeyPair instance) => <String, dynamic>{
      'public_key': instance.publicKey,
      'private_key': instance.privateKey,
    };
