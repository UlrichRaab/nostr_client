import 'dart:math';
import 'dart:typed_data';

import 'package:bip340/bip340.dart' as bip340;
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';

class Signer {
  const Signer();

  String sign({
    required String privateKey,
    required String message,
    String? aux,
  }) {
    final aux2 = aux ?? _createAux();
    return bip340.sign(privateKey, message, aux2);
  }

  String _createAux() {
    final secureRandom = _createSecureRandom();
    final bytes = secureRandom.nextBytes(32);
    return hex.encode(bytes);
  }

  SecureRandom _createSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    final keyParams = KeyParameter(Uint8List.fromList(seeds));
    secureRandom.seed(keyParams);
    return secureRandom;
  }
}
