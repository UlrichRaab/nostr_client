import 'dart:convert';

import 'package:pointycastle/export.dart';

class ECPublicKeyCodec extends Codec<ECPublicKey, String> {
  const ECPublicKeyCodec();

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
    throw UnimplementedError();
  }
}

class _Encoder extends Converter<ECPublicKey, String> {
  const _Encoder();

  @override
  String convert(ECPublicKey input) {
    final q = input.Q!;
    q.getEncoded();
    final x = q.x!;
    return x.toBigInteger()!.toRadixString(16);
  }
}
