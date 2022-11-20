import 'package:meta/meta.dart';

/// A pair of public and private keys.
@sealed
@immutable
class KeyPair {
  const KeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  /// The public key.
  final String publicKey;

  /// The private key.
  final String privateKey;

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
}
