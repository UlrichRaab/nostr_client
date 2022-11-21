import 'package:nostr_client/nostr_client.dart';
import 'package:test/test.dart';

void main() {
  final signer = Signer();
  final verifier = Verifier();

  test(
    'event_0',
    () {
      final sig = signer.sign(
        privateKey:
            '0B432B2677937381AEF05BB02A66ECD012773062CF3FA2549E44F58ED2401710',
        message:
            'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
        aux: 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
      );

      assert(
        sig ==
            '7EB0509757E246F19449885651611CB965ECC1A187DD51B64FDA1EDC9637D5EC97582B9CB13DB3933705B32BA982AF5AF25FD78881EBB32771FC5922EFC66EA3'
                .toLowerCase(),
      );

      final isValid = verifier.verify(
        publicKey:
            '25D1DFF95105F5253C4022F628A996AD3A0D95FBF21D468A1B33F8C160D8F517',
        message:
            'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
        signature: sig,
      );

      assert(isValid);
    },
  );
}
