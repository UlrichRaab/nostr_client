import 'dart:convert';

import 'package:nostr_client/nostr_client.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class Relay {
  const Relay._(
    this._channel,
  );

  factory Relay.connect(String url) {
    final channel = IOWebSocketChannel.connect(url);
    return Relay._(channel);
  }

  final IOWebSocketChannel _channel;

  Stream<Message> get stream {
    return _channel.stream.map((data) => jsonDecode(data) as Message);
  }

  String subscribe(Filter filter) {
    final subscriptionId = Uuid().v4();
    final message = ['REQ', subscriptionId, filter.toJson()];
    final request = jsonEncode(message);
    _channel.sink.add(request);
    return subscriptionId;
  }

  void unsubscribe(String subscriptionId) {
    final message = ['CLOSE', subscriptionId];
    final messageJson = jsonEncode(message);
    _channel.sink.add(messageJson);
  }
}
