import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final generator = RandomKeyPairGenerator();

  test('generate', () async {
    final keyPairs = <KeyPair>{};
    for (int i = 0; i < 10; i++) {
      final keyPair = generator.generate();
      keyPairs.add(keyPair);
    }
    assert(keyPairs.length == 10);
  });
}
