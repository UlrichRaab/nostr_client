import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final relayUrl = 'wss://relay.nostr.info';

  test(
    'get relay information docuemnt',
    () async {
      final relay = Relay(relayUrl);
      final relayInformationDocument = await relay.informationDocument;
      print(relayInformationDocument);
    },
  );

  test(
    'req kind 0 events (metadata)',
    () async {
      final relay = Relay(relayUrl)..connect();
      relay.stream.whereIsEvent().listen((event) {
        print(event);
        final userMetadata = Metadata.fromJsonString(event.content);
        print(userMetadata);
      });
      final filter = Filter(
        kinds: [EventKind.metadata],
        limit: 10,
      );
      final subscriptionId = relay.subscribe(filter);
      await Future.delayed(Duration(seconds: 5));
      relay.unsubscribe(subscriptionId);
      relay.disconnect();
    },
  );

  test(
    'req kind 1 events (text)',
    () async {
      final relay = Relay(relayUrl)..connect();
      relay.stream.whereIsEvent().listen((event) => print(event));
      final filter = Filter(
        kinds: [EventKind.text],
        limit: 10,
      );
      final subscriptionId = relay.subscribe(filter);
      await Future.delayed(Duration(seconds: 5));
      relay.unsubscribe(subscriptionId);
      relay.disconnect();
    },
  );
}
