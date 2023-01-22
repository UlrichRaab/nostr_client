import 'package:nostr_client/nostr_client.dart';
import 'package:uuid/uuid.dart';

/// A relay pool manages the connection and communication with multiple relays.
class RelayPool {
  const RelayPool._(this._relays);

  factory RelayPool({required Set<String> urls}) {
    final relays = <String, Relay>{};
    for (final url in urls) {
      relays[url] = Relay(url);
    }
    return RelayPool._(relays);
  }

  /// A map of key/value pairs where the key is a url and the value is the
  /// relay with that url.
  final Map<String, Relay> _relays;

  /// Subscribe to events that match the given [filter].
  ///
  /// Returns the id of the subscriptions.
  String subscribe(Filter filter, {String? subscriptionId}) {
    final sid = subscriptionId ?? Uuid().v4();
    for (final relay in _relays.values) {
      relay.subscribe(filter, subscriptionId: sid);
    }
    return sid;
  }

  /// Cancel the subscriptions with the given [subscriptionId].
  void unsubscribe(String subscriptionId) {
    for (final relay in _relays.values) {
      relay.unsubscribe(subscriptionId);
    }
  }
}
