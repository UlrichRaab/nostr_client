import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'nip05.dart';

class NIP05Service {
  final Map<String, Nip05> _cache = {};
  final http.Client _client;
  final StreamController<Nip05> _controller = StreamController();
  bool _isClosed = false;

  NIP05Service(this._client);

  Stream<Nip05> get stream {
    if (_isClosed) throw StateError('NIP05Service is closed');

    return _controller.stream.asBroadcastStream();
  }

  Future<void> close() async {
    if (_isClosed) return;

    _cache.clear();
    await _controller.close();
    _isClosed = true;
  }

  Future<Nip05> get(
    String pubkey,
    String address, {
    bool useCache = true,
  }) async {
    if (_isClosed) throw StateError('NIP05Service is closed');

    if (pubkey.isEmpty ||
        pubkey.length != 64 ||
        address.isEmpty ||
        !address.contains('@')) {
      throw ArgumentError(
          'Invalid arguments: pubkey: $pubkey, address: $address');
    }

    final cacheKey = '$pubkey:$address';
    if (useCache) {
      final nip05 = _getFromCache(cacheKey);
      if (nip05 != null) return nip05;
    }

    final nip05 = await _verify(pubkey, address);
    _controller.add(nip05);
    _cache[cacheKey] = nip05;

    return nip05;
  }

  Future<Nip05> _verify(String pubkey, String address) async {
    final spl = address.split('@');
    if (spl.length != 2) return Nip05.unverified();
    final name = spl[0];
    final domain = spl[1];

    late final Uri? uri;
    try {
      uri = Uri.tryParse(
        'https://$domain/.well-known/nostr.json?name=$name',
      );
    } catch (e) {
      return Nip05.unverified(domain, name);
    }

    final response = await _client.get(uri!);

    if (response.statusCode == 404) return Nip05.unverified(domain, name);

    if (response.statusCode != 200) {
      throw Exception("Error while fetching data from server");
    }

    if (response.body.isEmpty) return Nip05.unverified(domain, name);

    final json = jsonDecode(response.body);

    final body = json as Map<String, dynamic>;

    if (!body.containsKey('names')) return Nip05.unverified(domain, name);

    if (!body['names'].containsKey(name)) return Nip05.unverified(domain, name);

    final verifyKey = body['names'][name];

    if (verifyKey != pubkey) return Nip05.unverified(domain, name);

    return Nip05.verified(domain, name);
  }

  Nip05? _getFromCache(String cacheAddress) {
    if (_cache.containsKey(cacheAddress)) {
      return _cache[cacheAddress]!;
    }

    return null;
  }
}
