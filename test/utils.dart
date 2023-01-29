import 'dart:io';

import 'package:nostr_client/src/event.dart';

Future<Event> readEvent(String fileName) async {
  final file = File('test_data/events/$fileName.json');
  final jsonString = await file.readAsString();
  return Event.fromJsonString(jsonString);
}
