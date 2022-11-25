import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nostr_client/nostr_client.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class Relay {
  const Relay._(
    this._url,
    this._channel,
  );

  factory Relay.connect(String url) {
    final channel = IOWebSocketChannel.connect(url);
    return Relay._(url, channel);
  }

  final String _url;
  final IOWebSocketChannel _channel;

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

  /// Send the given [event] to the realy.
  void send(Event event) {
    final message = ['EVENT', event.toJson()];
    final request = jsonEncode(message);
    _channel.sink.add(request);
  }

  /// Subscribe to events that match the given [filter].
  ///
  /// Returns the id of the subscription.
  String req(Filter filter, {String? subscriptionId}) {
    final sid = subscriptionId ?? Uuid().v4();
    final message = ['REQ', sid, filter.toJson()];
    final request = jsonEncode(message);
    _channel.sink.add(request);
    return sid;
  }

  /// Close the subscription with the given [subscriptionId].
  void close(String subscriptionId) {
    final message = ['CLOSE', subscriptionId];
    final messageJson = jsonEncode(message);
    _channel.sink.add(messageJson);
  }

  /// Terminates the connection to the relay.
  ///
  /// Returns a future which is completed as soon as the connection is
  /// terminated. If cleaning up can fail, the error may be reported in the
  /// returned future.
  Future<void> disconnect() async {
    await _channel.sink.close();
  }
}
