import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'key_pair.g.dart';

/// A pair of public and private keys.
@sealed
@immutable
@JsonSerializable()
class KeyPair {
  const KeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  factory KeyPair.fromJson(Map<String, dynamic> json) {
    return _$KeyPairFromJson(json);
  }

  factory KeyPair.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return KeyPair.fromJson(json);
  }

  /// The public key.
  final String publicKey;

  /// The private key.
  final String privateKey;

  /// Converts this key pair to json.
  Map<String, dynamic> toJson() {
    return _$KeyPairToJson(this);
  }

  /// Converts this key pair to a json string.
  String toJsonString({bool pretty = false}) {
    final json = toJson();
    final encoder = pretty ? JsonEncoder.withIndent(' ' * 2) : JsonEncoder();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KeyPair &&
        other.publicKey == publicKey &&
        other.privateKey == privateKey;
  }

  @override
  int get hashCode {
    return Object.hash(
      publicKey,
      privateKey,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'KeyPair $jsonString';
  }
}
