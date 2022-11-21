import 'dart:convert';

import 'package:pointycastle/export.dart';

/// https://bips.xyz/340
class PublicKeyCodec extends Codec<ECPublicKey, String> {
  const PublicKeyCodec();

  @override
  Converter<String, ECPublicKey> get decoder => _Decoder();

  @override
  Converter<ECPublicKey, String> get encoder => _Encoder();
}

// Internal

class _Decoder extends Converter<String, ECPublicKey> {
  const _Decoder();

  @override
  ECPublicKey convert(String input) {
    final parameters = ECCurve_secp256k1();
    final curve = parameters.curve;
    final x = BigInt.parse(input, radix: 16);
    final q = curve.decompressPoint(0x02, x);
    return ECPublicKey(q, parameters);
  }
}

class _Encoder extends Converter<ECPublicKey, String> {
  const _Encoder();

  @override
  String convert(ECPublicKey input) {
    final q = input.Q!;
    final x = q.x!;
    return x.toBigInteger()!.toRadixString(16).padLeft(64, '0');
  }
}
