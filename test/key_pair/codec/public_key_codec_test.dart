import 'package:nostr_client/src/key_pair/codec/public_key_codec.dart';
import 'package:test/test.dart';

void main() {
  test(
    'decode -> encode',
    () async {
      final input = [
        '887645fef0ce0c3c1218d2f5d8e6132a19304cdc57cd20281d082f38cfea0072',
        'cd169bd8fbd5179e2a8d498ffc31d3ae0e40825ff2b8a85ea359c4455a107ca8',
        'ee11a5dff40c19a555f41fe42b48f00e618c91225622ae37b6c2bb67b76c4e49',
        '32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245',
        '44189afbf0d25716de6af793dc61c113ecf56166481912ce14c2052db62f396c',
        '00000000827ffaa94bfea288c3dfce4422c794fbb96625b6b31e9049f729d700',
        'd7e747f60a16bf0081c0a88184a34086cc13e6edb0662d4e55202531b47be026',
        '428107e3b4b05df1e13c42b3bacb3fddf54c7ed12630e91870d5d8d0b4a091de',
        'c7eda660a6bc8270530e82b4a7712acdea2e31dc0a56f8dc955ac009efd97c86',
        'f4a466ce15c1a2cf09a4f75d27a010eb80bc8af47efdd4202c60c9db9f7a0a16',
        '8c0da4862130283ff9e67d889df264177a508974e2feb96de139804ea66d6168',
        '00000017c61ccde5cd336346ec69a78ad8e6cdf99485637cc48439e0eb437582',
        '31d7b10d9a388d8d02c943ef728804e61fa444262cbba7ff7ca1523cd9be5384',
        '4b5520fd1bdcb6f11a8847e2c980f07ba873488a097467186ffeb68f955b9273',
        'a834d3d7362129042977e548dbb74abb4d170c598e2f724ed3bf1d44489cbe44',
        '80482e60178c2ce996da6d67577f56a2b2c47ccb1c84c81f2b7960637cb71b78',
        '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
        '3c2584f6bc370d6eab4129870df0bf7761eeebd2f627687fe64a7e0bbfcd120d',
        '68680737c76dabb801cb2204f57dbe4e4579e4f710cd67dc1b4227592c81e9b5',
        'de8ef91036c0d79596b65fef304cd759d4aabbd8c653b29077c0dccb32e4e9ef',
      ];

      final codec = PublicKeyCodec();
      for (String pubkey in input) {
        final publicKey = codec.decode(pubkey);
        final pubkey2 = codec.encode(publicKey);
        assert(pubkey == pubkey2);
      }
    },
  );
}
