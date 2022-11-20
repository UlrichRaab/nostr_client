import 'dart:math';
import 'dart:typed_data';

import 'package:nostr_client/nostr_client.dart';
import 'package:nostr_client/src/key_pair/ecc/ec_key_pair.dart';
import 'package:pointycastle/export.dart';

/// A key pair generator that generates random key pairs.
class RandomKeyPairGenerator implements KeyPairGenerator<dynamic> {
  const RandomKeyPairGenerator();

  @override
  KeyPair generate({dynamic params}) {
    final domainParams = ECCurve_secp256k1();
    final keyGeneratorParams = ECKeyGeneratorParameters(domainParams);
    final random = _createSecureRandom();
    final cipherParams = ParametersWithRandom(keyGeneratorParams, random);
    final generator = ECKeyGenerator();
    generator.init(cipherParams);
    final ecKeyPair = generator.generateKeyPair() as ECKeyPair;
    return KeyPair(
      publicKey: ecKeyPair.publicKey.toString(),
      privateKey: ecKeyPair.privateKey.toString(),
    );
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
