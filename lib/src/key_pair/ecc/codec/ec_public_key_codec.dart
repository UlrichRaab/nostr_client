import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';

class ECPublicKeyCodec extends Codec<ECPublicKey, List<int>> {
  const ECPublicKeyCodec._({
    required this.decoder,
    required this.encoder,
  });

  /// [RFC-5480](https://www.rfc-editor.org/rfc/rfc5480)
  const ECPublicKeyCodec.rfc5480()
      : this._(
          decoder: const _RFC5480Decoder(),
          encoder: const _RFC5480Encoder(),
        );

  @override
  final Converter<List<int>, ECPublicKey> decoder;

  @override
  final Converter<ECPublicKey, List<int>> encoder;
}

// RFC 5480

class _RFC5480Decoder extends Converter<List<int>, ECPublicKey> {
  const _RFC5480Decoder();

  @override
  ECPublicKey convert(List<int> input) {
    var bytes = Uint8List.fromList(input);
    // Fix for UnsupportedASN1TagException: Tag 0 is not supported yet.
    if (bytes.first == 0) {
      bytes = bytes.sublist(1);
    }

    final rootParser = ASN1Parser(bytes);
    final rootSeq = rootParser.nextObject() as ASN1Sequence;

    final algorithmSeq = rootSeq.elements![0] as ASN1Sequence;
    final algorithmOi = algorithmSeq.elements![0] as ASN1ObjectIdentifier;
    final algorithm = algorithmOi.readableName;
    if (algorithm != 'ecPublicKey') {
      throw ArgumentError(
        'Invalid cryptographic algorithm $algorithm',
      );
    }

    final curveNameOi = algorithmSeq.elements![1] as ASN1ObjectIdentifier;
    final curveName = curveNameOi.readableName!;

    final subjectPublicKey = rootSeq.elements![1] as ASN1BitString;
    var subjectPublicKeyBytes = subjectPublicKey.valueBytes!;
    if (subjectPublicKeyBytes[0] == 0) {
      subjectPublicKeyBytes = subjectPublicKeyBytes.sublist(1);
    }

    final parameters = ECDomainParameters(curveName);
    final q = parameters.curve.decodePoint(subjectPublicKeyBytes);
    return ECPublicKey(q, parameters);
  }
}

class _RFC5480Encoder extends Converter<ECPublicKey, List<int>> {
  const _RFC5480Encoder();

  @override
  Uint8List convert(ECPublicKey input) {
    final algorithm = ASN1Sequence(
      elements: [
        ASN1ObjectIdentifier.fromName('ecPublicKey'),
        ASN1ObjectIdentifier.fromName(input.parameters!.domainName),
      ],
    );

    final subjectPublicKey = ASN1BitString(
      stringValues: input.Q!.getEncoded(false),
    );

    final root = ASN1Sequence(
      elements: [
        algorithm,
        subjectPublicKey,
      ],
    );

    return root.encode();
  }
}
