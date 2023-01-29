import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  final verifier = Verifier();

  test(
    'event_0',
    () async {
      final event = await readEvent('event_0');
      final isValid = verifier.verify(
        publicKey: event.pubkey,
        message: event.id,
        signature: event.sig,
      );
      assert(isValid);
    },
  );

  test(
    'event_1',
    () async {
      final event = await readEvent('event_1');
      final isValid = verifier.verify(
        publicKey: event.pubkey,
        message: event.id,
        signature: event.sig,
      );
      assert(isValid);
    },
  );

  test(
    'event_2',
    () async {
      final event = await readEvent('event_2');
      final isValid = verifier.verify(
        publicKey: event.pubkey,
        message: event.id,
        signature: event.sig,
      );
      assert(isValid);
    },
  );
}
