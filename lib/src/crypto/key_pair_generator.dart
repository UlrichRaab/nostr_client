import 'package:nostr_client/nostr_client.dart';
import 'package:nostr_client/src/crypto/ecc/ec_key_pair_generator.dart';

/// A generator to create a pair of public and private keys.
abstract class KeyPairGenerator {
  // ignore: unused_element
  const KeyPairGenerator._();

  factory KeyPairGenerator.random() {
    return ECKeyPairGenerator();
  }

  KeyPair generate();
}
