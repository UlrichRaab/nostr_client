import 'package:nostr_client/nostr_client.dart';

typedef Message = List<dynamic>;

extension MessageX on Message {
  bool get isClose => this[0] == 'CLOSE';
  bool get isEose => this[0] == 'EOSE';
  bool get isEvent => this[0] == 'EVENT';
  bool get isNotice => this[0] == 'NOTICE';
  bool get isOk => this[0] == 'OK';
  bool get isReq => this[0] == 'REQ';
}

extension MessageStreamX on Stream<Message> {
  /// Creates a new stream from this stream that emits only events and discards
  /// all other messages.
  Stream<Event> whereIsEvent() {
    return where((message) => message.isEvent).map(_messageToEvent);
  }

  Event _messageToEvent(Message message) {
    final json = message[2];
    return Event.fromJson(json);
  }
}
