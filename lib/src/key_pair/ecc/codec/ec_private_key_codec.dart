import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart';

class ECPrivateKeyCodec extends Codec<ECPrivateKey, List<int>> {
  const ECPrivateKeyCodec._({
    required this.decoder,
    required this.encoder,
  });

  /// PKCS#8 codec for EC private keys.
  ///
  /// [RFC-5208](https://www.rfc-editor.org/rfc/rfc5208)
  const ECPrivateKeyCodec.rfc5208()
      : this._(
          decoder: const _RFC5208Decoder(),
          encoder: const _RFC5208Encoder(),
        );

  /// SEC1 codec for EC private keys.
  ///
  /// [RFC-5915](https://www.rfc-editor.org/rfc/rfc5915)
  const ECPrivateKeyCodec.rfc5915()
      : this._(
          decoder: const _RFC5915Decoder(),
          encoder: const _RFC5915Encoder(),
        );

  @override
  final Converter<Uint8List, ECPrivateKey> decoder;

  @override
  final Converter<ECPrivateKey, Uint8List> encoder;
}

// RFC 5208 - PKCS#8

class _RFC5208Decoder extends Converter<Uint8List, ECPrivateKey> {
  const _RFC5208Decoder();

  @override
  ECPrivateKey convert(Uint8List input) {
    throw UnimplementedError();
  }
}

class _RFC5208Encoder extends Converter<ECPrivateKey, Uint8List> {
  const _RFC5208Encoder();

  @override
  Uint8List convert(ECPrivateKey input) {
    final rootSeq = ASN1Sequence(
      elements: [
        _version(),
        _privateKeyAlgorithm(input),
        _privateKey(input),
      ],
    );
    return rootSeq.encode();
  }

  ASN1Integer _version() {
    return ASN1Integer.fromtInt(0);
  }

  ASN1Sequence _privateKeyAlgorithm(ECPrivateKey ecPrivateKey) {
    return ASN1Sequence(
      elements: [
        ASN1ObjectIdentifier.fromName('ecPublicKey'),
        ASN1ObjectIdentifier.fromName(ecPrivateKey.parameters!.domainName),
      ],
    );
  }

  ASN1OctetString _privateKey(ECPrivateKey ecPrivateKey) {
    Uint8List privateKeyBytes = encodeBigInt(ecPrivateKey.d);
    if (privateKeyBytes.length.isOdd) {
      privateKeyBytes = Uint8List.fromList([0, ...privateKeyBytes]);
    }
    final privateKeySeq = ASN1Sequence(
      elements: [
        ASN1Integer.fromtInt(1),
        ASN1OctetString(octets: privateKeyBytes),
      ],
    );
    return ASN1OctetString(octets: privateKeySeq.encode());
  }
}

// RFC 5915 - SEC1

class _RFC5915Decoder extends Converter<Uint8List, ECPrivateKey> {
  const _RFC5915Decoder();

  @override
  ECPrivateKey convert(Uint8List input) {
    return ECPrivateKey(
      _d(input),
      _parameters(input),
    );
  }

  BigInt _d(Uint8List input) {
    final rootParser = ASN1Parser(input);
    final rootSeq = rootParser.nextObject() as ASN1Sequence;
    final privateKeyOctetString = rootSeq.elements![1] as ASN1OctetString;
    return decodeBigInt(privateKeyOctetString.valueBytes!);
  }

  ECDomainParameters _parameters(Uint8List input) {
    final rootParser = ASN1Parser(input);
    final rootSeq = rootParser.nextObject() as ASN1Sequence;
    final parametersSeq = rootSeq.elements![2];
    final parametersParser = ASN1Parser(parametersSeq.valueBytes);
    final domainNameOi = parametersParser.nextObject() as ASN1ObjectIdentifier;
    final domainName = domainNameOi.readableName!;
    return ECDomainParameters(domainName);
  }
}

class _RFC5915Encoder extends Converter<ECPrivateKey, Uint8List> {
  const _RFC5915Encoder();

  @override
  Uint8List convert(ECPrivateKey input) {
    final root = ASN1Sequence(
      elements: [
        _version(1),
        _privateKey(input),
        _parameters(input),
        _publicKey(input),
      ],
    );
    return root.encode();
  }

  ASN1Integer _version(int value) {
    return ASN1Integer.fromtInt(value);
  }

  ASN1OctetString _privateKey(ECPrivateKey ecPrivateKey) {
    Uint8List bytes = encodeBigInt(ecPrivateKey.d);
    if (bytes.length.isOdd) {
      bytes = Uint8List.fromList([0, ...bytes]);
    }
    return ASN1OctetString(octets: bytes);
  }

  ASN1Sequence _parameters(ECPrivateKey ecPrivateKey) {
    return ASN1Sequence(
      tag: 0xA0,
      elements: [
        ASN1ObjectIdentifier.fromName(ecPrivateKey.parameters!.domainName),
      ],
    );
  }

  ASN1Sequence _publicKey(ECPrivateKey ecPrivateKey) {
    final q = ecPrivateKey.parameters!.G * ecPrivateKey.d!;
    return ASN1Sequence(
      tag: 0xA1,
      elements: [
        ASN1BitString(stringValues: q!.getEncoded(false)),
      ],
    );
  }
}
