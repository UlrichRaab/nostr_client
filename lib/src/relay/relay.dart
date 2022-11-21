import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nostr_client/nostr_client.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class Relay {
  const Relay._(
    this._url,
    this._channel,
    this._subscriptionIds,
  );

  factory Relay.connect(String url) {
    final channel = IOWebSocketChannel.connect(url);
    return Relay._(url, channel, {});
  }

  final String _url;
  final IOWebSocketChannel _channel;
  final Set<String> _subscriptionIds;

  /// The relay information document of the relay.
  Future<RelayInformationDocument> get informationDocument async {
    final url = Uri.parse(_url).replace(scheme: 'https');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/nostr+json'},
    );
    return RelayInformationDocument.fromJsonString(response.body);
  }

  /// A stream which emits all messages sent by the relay.
  Stream<Message> get stream {
    return _channel.stream.map((data) => jsonDecode(data) as Message);
  }

  /// Publish the given [event].
  void publish(Event event) {
    final message = ['EVENT', event.toJson()];
    final request = jsonEncode(message);
    _channel.sink.add(request);
  }

  /// Subscribe to events that match the given [filter].
  ///
  /// Returns the id of the subscription.
  String req(Filter filter, {String? subscriptionId}) {
    final id = subscriptionId ?? Uuid().v4();
    final message = ['REQ', id, filter.toJson()];
    final request = jsonEncode(message);
    _channel.sink.add(request);
    _subscriptionIds.add(id);
    return id;
  }

  /// Close the subscription with the given [subscriptionId].
  void close(String subscriptionId) {
    final message = ['CLOSE', subscriptionId];
    final messageJson = jsonEncode(message);
    _channel.sink.add(messageJson);
    _subscriptionIds.remove(subscriptionId);
  }

  void disconnect() {
    for (var subscriptionId in _subscriptionIds) {
      close(subscriptionId);
    }
  }
}
