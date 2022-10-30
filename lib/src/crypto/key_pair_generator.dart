import 'dart:math';
import 'dart:typed_data';

import 'package:nostr_client/nostr_client.dart';
import 'package:pointycastle/export.dart';

class KeyPairGenerator {
  const KeyPairGenerator();

  KeyPair generate() {
    // Initialize the EC key generator parameters.
    final domainParams = ECCurve_secp256k1();
    final keyGeneratorParams = ECKeyGeneratorParameters(domainParams);
    final random = _createSecureRandom();
    final cipherParams = ParametersWithRandom(keyGeneratorParams, random);

    // Create and initialze the EC key generator,
    final generator = ECKeyGenerator();
    generator.init(cipherParams);

    // Generate the EC key pair.
    final ecKeyPair = generator.generateKeyPair();
    final ecPrivateKey = ecKeyPair.privateKey as ECPrivateKey;
    final ecPublicKey = ecKeyPair.publicKey as ECPublicKey;

    return KeyPair(private: '', public: '');
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
