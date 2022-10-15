import 'package:nostr_client/nostr_client.dart';

void main() {
  final relay = Relay(
    url: Uri.parse('wss://nostr-relay.untethr.me'),
  );

  relay.connect();
}
