import 'package:convert/convert.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

void main() {
  final publicKey =
      '137d948a0eee45e6cd113faaad934fcf17a97de2236c655b70650d4252daa9d3';

  test(
    'lab',
    () async {
      final parameters = ECCurve_secp256k1();
      final curve = parameters.curve;
      final x1 = BigInt.parse(publicKey, radix: 16);
      final q = curve.decompressPoint(0x02 & 1, x1);
      final pubkey = ECPublicKey(q, parameters);
    },
  );
}
