import 'package:nostr_client/nostr_client.dart';

void main() async {
  // Create a new relay instance and connect to the relay
  final relay = Relay('wss://relay.nostr.info');
  relay.connect();

  // Print events sent by the relay
  relay.stream.whereIsEvent().listen(((event) async {
    if (event.kind == EventKind.metadata) {
      final m = await Metadata.withCheckedNip05(event);
      print(m);
      return;
    }

    print(event);
  }));

  // Request text events from the relay and subscribe to updates
  final filter = Filter(
    kinds: [EventKind.text],
    limit: 10,
  );
  final subscriptionId = relay.subscribe(filter);

  final metadataFilter = Filter(
    authors: [
      '82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2', // @jack
    ],
    kinds: [EventKind.metadata, EventKind.recommendRelay],
  );
  final metaSubscriptionId = relay.subscribe(metadataFilter);

  // wait 5 seconds for the data to arrive
  await Future.delayed(Duration(seconds: 5));

  // Cancel the subscription
  relay.unsubscribe(subscriptionId);
  relay.unsubscribe(metaSubscriptionId);

  // Disconnect from the relay
  relay.disconnect();
}
