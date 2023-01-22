import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:nostr_client/nostr_client.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

final _log = Logger('Relay');

class Relay {
  Relay(this.url);

  final String url;
  IOWebSocketChannel? _channel;

  /// The relay information document of the relay.
  Future<RelayInformationDocument> get informationDocument async {
    final url = Uri.parse(this.url).replace(scheme: 'https');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/nostr+json'},
    );
    return RelayInformationDocument.fromJsonString(response.body);
  }

  /// A stream which emits all messages sent by the relay.
  Stream<Message> get stream {
    if (!isConnected) throw StateError('Not connected to $url');
    return _channel!.stream.map((data) => jsonDecode(data) as Message);
  }

  /// The connection state to the relay.
  bool get isConnected {
    final channel = _channel;
    if (channel == null) return false;
    return channel.closeCode == null;
  }

  /// Creates a new connection to the relay.
  void connect() {
    _log.fine('Connect to $url');
    if (isConnected) return;
    _channel = IOWebSocketChannel.connect(url);
  }

  /// Terminates the connection to the relay.
  ///
  /// Returns a future which is completed as soon as the connection is
  /// terminated. If cleaning up can fail, the error may be reported in the
  /// returned future.
  Future<void> disconnect() async {
    _log.fine('Disconnect from $url');
    await _channel?.sink.close();
    _channel = null;
  }

  /// Send the given [event] to the realy.
  ///
  /// Throws a [StateError] if there is no connection to the relay.
  void send(Event event) {
    if (!isConnected) throw StateError('Not connected to $url');
    final message = ['EVENT', event.toJson()];
    final request = jsonEncode(message);
    _channel!.sink.add(request);
  }

  /// Subscribe to events that match the given [filter].
  ///
  /// Returns the id of the subscription.
  String subscribe(Filter filter, {String? subscriptionId}) {
    if (!isConnected) throw StateError('Not connected to $url');
    final sid = subscriptionId ?? Uuid().v4();
    final message = ['REQ', sid, filter.toJson()];
    final request = jsonEncode(message);
    _channel!.sink.add(request);
    return sid;
  }

  /// Cancel the subscription with the given [subscriptionId].
  void unsubscribe(String subscriptionId) {
    if (!isConnected) throw StateError('Not connected to $url');
    final message = ['CLOSE', subscriptionId];
    final messageJson = jsonEncode(message);
    _channel!.sink.add(messageJson);
  }
}
