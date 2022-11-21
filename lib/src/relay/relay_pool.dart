import 'package:nostr_client/nostr_client.dart';

/// A relay pool manages the connection and communication with multiple relays.
class RelayPool {
  const RelayPool._(this._relays);

  factory RelayPool({required Set<String> urls}) {
    final relays = <String, Relay>{};
    for (final url in urls) {
      relays[url] = Relay.connect(url);
    }
    return RelayPool._(relays);
  }

  /// A map of key/value pairs where the key is a url and the value is the
  /// relay with that url.
  final Map<String, Relay> _relays;

  List<String> req(Filter filter) {
    final subscriptionIds = <String>[];
    for (final relay in _relays.values) {
      final subscriptionId = relay.req(filter);
      subscriptionIds.add(subscriptionId);
    }
    return subscriptionIds;
  }

  void close(String subscriptionId) {
    for (final relay in _relays.values) {
      relay.close(subscriptionId);
    }
  }
}
