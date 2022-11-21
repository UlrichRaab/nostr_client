import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final relayUrl = 'wss://relay.nostr.info';

  test(
    'req kind 0 events (user metadata)',
    () async {
      final relay = Relay.connect(relayUrl);
      relay.stream.whereIsEvent().whereIsKind(0).listen((event) {
        final jsonString = event.content;
        final userMetadata = UserMetadata.fromJsonString(jsonString);
        final p = userMetadata.toString();
        print(p);
      });

      final filter = Filter(kinds: [0]);
      final subscriptionId = relay.req(filter);
      await Future.delayed(Duration(seconds: 5));
      return relay.close(subscriptionId);
    },
  );
}
