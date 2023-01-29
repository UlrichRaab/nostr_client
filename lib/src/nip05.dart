import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'nip05.g.dart';

@sealed
@immutable
@JsonSerializable()

/// Mapping Nostr keys to DNS-based internet identifiers
///
/// https://github.com/nostr-protocol/nips/blob/master/05.md
class Nip05 {
  /// Whether the NIP05 address was verified.
  final bool verified;

  /// Name of the NIP05 address.
  final String name;

  /// Domain of the the NIP05 address.
  final String domain;

  /// If the NIP05 was verified, this is the time when it was verified.
  /// If a verification was not attempted, this is null.
  final DateTime? verifiedAt;

  const Nip05({
    this.verified = false,
    this.name = '',
    this.domain = '',
    this.verifiedAt,
  });

  factory Nip05.fromJson(Map<String, dynamic> json) {
    return _$Nip05FromJson(json);
  }

  /// Get a NIP05 address from a string.
  ///
  /// The string must be in the format of `name@domain`.
  factory Nip05.fromAddress(String address) {
    if (!address.contains('@')) throw ArgumentError('Invalid address');

    final spl = address.split('@');
    if (spl.length != 2) return Nip05.unverified();
    final name = spl[0];
    final domain = spl[1];

    return Nip05.unverified(domain, name);
  }

  Map<String, dynamic> toJson() {
    return _$Nip05ToJson(this);
  }

  /// get a verified NIP05 object with verification not of DateTime.now().
  Nip05.verified(this.domain, this.name)
      : verified = true,
        verifiedAt = DateTime.now();

  /// get a unverified NIP05 object with verification not of DateTime.now().
  Nip05.unverified([this.domain = '', this.name = ''])
      : verified = false,
        verifiedAt = DateTime.now();

  /// copy the NIP05 object with new values.
  Nip05 copyWith({
    bool? verified,
    String? name,
    String? domain,
    DateTime? verifiedAt,
  }) {
    return Nip05(
      verified: verified ?? this.verified,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}
