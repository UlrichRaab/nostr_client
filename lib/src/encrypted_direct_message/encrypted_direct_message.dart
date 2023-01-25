import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:nostr_client/nostr_client.dart';

part 'encrypted_direct_message.g.dart';

@sealed
@immutable
@JsonSerializable()
class EncryptedDirectMessage {
  const EncryptedDirectMessage({
    required this.cipherText,
    required this.iv,
  });

  /// The base64 encoded cipher text of the direct message.
  final String cipherText;

  /// The base64 encoded initialization vector which was used for encryption.
  final String iv;

  /// Decrypts this encrypted direct message and returns the decrypted plain
  /// text.
  String decrypt(KeyPair keyPair) {
    throw UnimplementedError();
  }

  /// Converts this encrypted direct message to json.
  Map<String, dynamic> toJson() {
    return _$EncryptedDirectMessageToJson(this);
  }

  /// Converts this encrypted direct message to a json string.
  String toJsonString({bool pretty = false}) {
    final json = toJson();
    final indent = pretty ? ' ' * 2 : null;
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EncryptedDirectMessage &&
        other.cipherText == cipherText &&
        other.iv == iv;
  }

  @override
  int get hashCode {
    return Object.hash(
      cipherText,
      iv,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'EncryptedDirectMessage $jsonString';
  }
}
