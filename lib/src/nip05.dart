import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'nip05.g.dart';

@sealed
@immutable
@JsonSerializable()
class Nip05 {
  final bool verified;
  final String name;
  final String domain;
  final DateTime? verifiedAt;

  const Nip05([
    this.verified = false,
    this.name = '',
    this.domain = '',
    this.verifiedAt,
  ]);

  factory Nip05.fromJson(Map<String, dynamic> json) {
    return _$Nip05FromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$Nip05ToJson(this);
  }

  static Future<Nip05> verifyNip05(String pubkey, String nip05String) async {
    // https: //example.com/.well-known/nostr.json?name=bob
    final spl = nip05String.split('@');
    if (spl.length != 2) return Nip05.unverified();
    final name = spl[0];
    final domain = spl[1];

    final uri = Uri.tryParse(
      'https://$domain/.well-known/nostr.json?name=$name',
    );
    if (uri == null) return Nip05.unverified();

    final res = await http.read(uri);
    final nip05Res = jsonDecode(res);
    if (!nip05Res.containsKey('names')) return Nip05.unverified(domain);

    if (!nip05Res['names'].containsKey(name)) return Nip05.unverified(domain);

    final verifyKey = nip05Res['names'][name];
    if (verifyKey != pubkey) return Nip05.unverified(domain);

    return Nip05.verified(domain, name);
  }

  Nip05.verified(this.domain, this.name)
      : verified = true,
        verifiedAt = DateTime.now();

  Nip05.unverified([this.domain = '', this.name = ''])
      : verified = false,
        verifiedAt = DateTime.now();
}
