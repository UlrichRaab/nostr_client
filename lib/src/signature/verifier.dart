import 'package:bip340/bip340.dart' as bip340;

class Verifier {
  const Verifier();

  /// Verifies the given signature.
  bool verify({
    required String publicKey,
    required String message,
    required String signature,
  }) {
    return bip340.verify(publicKey, message, signature);
  }
}
