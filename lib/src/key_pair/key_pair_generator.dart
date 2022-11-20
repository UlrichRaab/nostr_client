import 'package:nostr_client/nostr_client.dart';

/// A generator that generates key pairs.
abstract class KeyPairGenerator<T> {
  const KeyPairGenerator._();

  KeyPair generate({T params});
}
