import 'package:collection/collection.dart';

/// A filter determines what events will be sent in a subscription.
class Filter {
  const Filter({
    this.ids,
    this.authors,
    this.kinds,
    this.e,
    this.p,
    this.since,
    this.until,
    this.limit,
  });

  /// A list of event ids or prefixes.
  final List<String>? ids;

  /// A list of pubkeys or prefixes, the pubkey of an event must be one of
  /// these.
  final List<String>? authors;

  /// A list of a kind numbers.
  final List<int>? kinds;

  /// A list of event ids that are referenced in an **e** tag.
  final List<String>? e;

  /// A list of pubkeys that are referenced in a **p** tag.
  final List<String>? p;

  /// A timestamp, events must be newer than this to pass.
  final DateTime? since;

  /// A timestamp, events must be older than this to pass.
  final DateTime? until;

  /// Maximum number of events to be returned in the initial query.
  final int? limit;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Filter &&
        ListEquality().equals(other.ids, ids) &&
        ListEquality().equals(other.authors, authors) &&
        ListEquality().equals(other.kinds, kinds) &&
        ListEquality().equals(other.e, e) &&
        ListEquality().equals(other.p, p) &&
        other.since == since &&
        other.until == until &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return Object.hash(
      ids != null ? Object.hashAll(ids!) : null,
      authors != null ? Object.hashAll(authors!) : null,
      kinds != null ? Object.hashAll(kinds!) : null,
      e != null ? Object.hashAll(e!) : null,
      p != null ? Object.hashAll(p!) : null,
      since,
      until,
      limit,
    );
  }
}
