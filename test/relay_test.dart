import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  late final Relay relay;

  setUp(() {
    relay = Relay.connect('wss://relay.nostr.info');
    relay.stream.listen((message) {
      print(message);
    });
  });

  test(
    'subscribe',
    () async {
      final filter = Filter(
        kinds: [1],
        limit: 100,
      );

      for (int i = 0; i < 1; i++) {
        final subscriptionId = relay.subscribe(filter);
        await Future.delayed(Duration(seconds: 5));
        return relay.unsubscribe(subscriptionId);
      }
    },
  );
}
