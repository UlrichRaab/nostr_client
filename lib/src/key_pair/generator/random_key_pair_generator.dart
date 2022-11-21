import 'dart:math';
import 'dart:typed_data';

import 'package:nostr_client/nostr_client.dart';
import 'package:nostr_client/src/key_pair/codec/private_key_codec.dart';
import 'package:nostr_client/src/key_pair/codec/public_key_codec.dart';
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
    final ecKeyPair = generator.generateKeyPair();
    final ecPublicKey = ecKeyPair.publicKey as ECPublicKey;
    final ecPrivateKey = ecKeyPair.privateKey as ECPrivateKey;
    return KeyPair(
      publicKey: PublicKeyCodec().encode(ecPublicKey),
      privateKey: PrivateKeyCodec().encode(ecPrivateKey),
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
