import 'package:nostr_client/nostr_client.dart';
import 'package:nostr_client/src/crypto/ecc/codec/ec_private_key_codec.dart';
import 'package:nostr_client/src/crypto/ecc/codec/ec_public_key_codec.dart';
import 'package:pointycastle/pointycastle.dart';

class ECKeyPair extends AsymmetricKeyPair<ECPublicKey, ECPrivateKey> {
  ECKeyPair(super.publicKey, super.privateKey);

  KeyPair toKeyPair() {
    return KeyPair(
      publicKey: ECPublicKeyCodec().encode(publicKey),
      privateKey: ECPrivateKeyCodec().encode(privateKey),
    );
  }
}

// Extensions

extension KeyPairX on KeyPair {
  ECKeyPair toECKeyPair() {
    return ECKeyPair(
      ECPublicKeyCodec().decode(publicKey),
      ECPrivateKeyCodec().decode(privateKey),
    );
  }
}
