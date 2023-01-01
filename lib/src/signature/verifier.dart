import 'package:bip340/bip340.dart' as bip340;
import 'package:nostr_client/nostr_client.dart';

class Verifier {
  const Verifier();

  /// Verifies the given signature.
  ///
  /// Returns true if the signature is valid, false otherwise.
  bool verify({
    required String publicKey,
    required String message,
    required String signature,
  }) {
    return bip340.verify(publicKey, message, signature);
  }

  /// Verifies the given event.
  ///
  /// Returns true if the event is valid, false otherwise.
  bool verifyEvent(Event event) {
    return verify(
      publicKey: event.pubkey,
      message: event.id,
      signature: event.sig,
    );
  }
}
