import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final relayUrl = 'wss://relay.nostr.info';

  test(
    'req kind 0 events (metadata)',
    () async {
      final relay = Relay.connect(relayUrl);
      relay.stream.whereIsEvent().listen((event) {
        print(event);
        final userMetadata = Metadata.fromJsonString(event.content);
        print(userMetadata);
      });
      final filter = Filter(
        kinds: [EventKind.metadata],
        limit: 10,
      );
      final subscriptionId = relay.req(filter);
      await Future.delayed(Duration(seconds: 5));
      return relay.close(subscriptionId);
    },
  );

  test(
    'req kind 1 events (text)',
    () async {
      final relay = Relay.connect(relayUrl);
      relay.stream.whereIsEvent().listen((event) => print(event));
      final filter = Filter(
        kinds: [EventKind.text],
        limit: 10,
      );
      final subscriptionId = relay.req(filter);
      await Future.delayed(Duration(seconds: 5));
      return relay.close(subscriptionId);
    },
  );
}
