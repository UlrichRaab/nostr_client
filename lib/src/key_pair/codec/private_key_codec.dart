import 'dart:convert';

import 'package:pointycastle/export.dart';

class PrivateKeyCodec extends Codec<ECPrivateKey, String> {
  const PrivateKeyCodec();

  @override
  Converter<String, ECPrivateKey> get decoder => _Decoder();

  @override
  Converter<ECPrivateKey, String> get encoder => _Encoder();
}

// Internal

class _Decoder extends Converter<String, ECPrivateKey> {
  const _Decoder();

  @override
  ECPrivateKey convert(String input) {
    final d = BigInt.parse(input, radix: 16);
    return ECPrivateKey(d, ECCurve_secp256k1());
  }
}

class _Encoder extends Converter<ECPrivateKey, String> {
  const _Encoder();

  @override
  String convert(ECPrivateKey input) {
    final d = input.d;
    if (d == null) {
      final msg = 'The private parameter d of the ECC private key is null.';
      throw ArgumentError(msg);
    }
    return d.toRadixString(16);
  }
}
