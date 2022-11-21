import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  late final Relay relay;

  setUp(() {
    relay = Relay.connect('wss://relay.nostr.info');
    relay.stream.listen(printMessage);
  });

  test(
    'req',
    () async {
      final filter = Filter(
        kinds: [1],
        limit: 100,
      );

      for (int i = 0; i < 1; i++) {
        final subscriptionId = relay.req(filter);
        await Future.delayed(Duration(seconds: 5));
        return relay.close(subscriptionId);
      }
    },
  );
}

printMessage(List<dynamic> message) {
  final type = message.first;
  if (type == 'EVENT') {
    final json = message[2];
    printEvent(json);
  } else {
    print('Message(type: $type)');
  }
}

printEvent(Map<String, dynamic> json) {
  final event = Event.fromJson(json);
  print(event.toString());
}
