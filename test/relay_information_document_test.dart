import 'dart:io';

import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  test(
    'fromJson()',
    () async {
      final path = 'test_data/relay_information_document.json';
      final jsonString = await File(path).readAsString();
      RelayInformationDocument.fromJsonString(jsonString);
    },
  );
}
