import 'package:nostr_client/nostr_client.dart';

void main() {
  // Create a new relay instance and connect to the relay
  final relay = Relay('wss://relay.nostr.info');
  relay.connect();

  // Print events sent by the relay
  relay.stream.whereIsEvent().listen(print);

  // Request text events from the relay and subscribe to updates
  final filter = Filter(
    kinds: [EventKind.text],
    limit: 10,
  );
  final subscriptionId = relay.subscribe(filter);

  // Cancel the subscription
  relay.unsubscribe(subscriptionId);

  // Disconnect from the relay
  relay.disconnect();
}
