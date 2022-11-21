import 'dart:io';

import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final verifier = Verifier();

  test(
    'event_0',
    () async {
      final event = await _readEvent('event_0');
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
      final event = await _readEvent('event_1');
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
      final event = await _readEvent('event_2');
      final isValid = verifier.verify(
        publicKey: event.pubkey,
        message: event.id,
        signature: event.sig,
      );
      assert(isValid);
    },
  );
}

Future<Event> _readEvent(String fileName) async {
  final file = File('test_data/events/$fileName.json');
  final jsonString = await file.readAsString();
  return Event.fromJsonString(jsonString);
}
