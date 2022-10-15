import 'package:web_socket_channel/io.dart';

class Relay {
  Relay({
    required this.url,
  });

  final Uri url;

  IOWebSocketChannel? _channel;

  void connect() {
    if (_channel != null) return;
  }
}
