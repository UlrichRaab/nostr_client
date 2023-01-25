// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encrypted_direct_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptedDirectMessage _$EncryptedDirectMessageFromJson(
        Map<String, dynamic> json) =>
    EncryptedDirectMessage(
      cipherText: json['cipher_text'] as String,
      iv: json['iv'] as String,
    );

Map<String, dynamic> _$EncryptedDirectMessageToJson(
        EncryptedDirectMessage instance) =>
    <String, dynamic>{
      'cipher_text': instance.cipherText,
      'iv': instance.iv,
    };
