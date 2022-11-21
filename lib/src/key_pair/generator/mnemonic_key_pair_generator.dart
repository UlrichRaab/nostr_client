import 'package:nostr_client/nostr_client.dart';

/// A key pair generator that generates key pairs by using a list of easy to
/// remember words.
///
/// [NIP-06](https://github.com/nostr-protocol/nips/blob/master/06.md)
class MnemonicKeyPairGenerator implements KeyPairGenerator<List<String>> {
  const MnemonicKeyPairGenerator();

  @override
  KeyPair generate({List<String> params = const []}) {
    throw UnimplementedError();
  }
}
