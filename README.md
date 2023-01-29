# nostr_client 0.2.0

A nostr client for dart and flutter.

## Features

- [x] [NIP-01: Basic protocol flow description][nip01]
- [ ] [NIP-02: Contact List and Petnames][nip02]
- [ ] [NIP-03: OpenTimestamps Attestations for Events][nip03]
- [ ] [NIP-04: Encrypted Direct Message][nip04]
- [x] [NIP-05: Mapping Nostr keys to DNS-based internet identifiers][nip05]
- [ ] [NIP-06: Basic key derivation from mnemonic seed phrase][nip06]
- [ ] [NIP-07: window.nostr capability for web browsers][nip07]
- [ ] [NIP-08: Handling Mentions][nip08]
- [ ] [NIP-09: Event Deletion][nip09]
- [ ] [NIP-10: Conventions for clients' use of e and p tags in text events.][nip10]
- [x] [NIP-11: Relay Information Document][nip11]
- [ ] [NIP-12: Generic Tag Queries][nip12]
- [ ] [NIP-13: Proof of Work][nip13]
- [ ] [NIP-14: Subject tag in text events.][nip14]
- [ ] [NIP-15: End of Stored Events Notice][nip15]
- [ ] [NIP-16: Event Treatment][nip16]
- [ ] [NIP-20: Command Results][nip20]
- [ ] [NIP-22: Event created_at Limits][nip22]
- [ ] [NIP-25: Reactions][nip25]
- [ ] [NIP-28: Public Chat][nip28]
- [ ] [NIP-35: User Discovery][nip35]

## Getting Started

Add this package to the `pubspec.yaml` of your flutter project:

```yaml
dependencies:
  nostr_client: ^0.2.0
```

## Usage

```dart
import 'package:nostr_client/nostr_client.dart'

// Create a new relay instance and connect to the relay
final relay = Relay('wss://relay.nostr.info');
relay.connect();

// Print events sent by the relay
relay.stream.whereIsEvent().listen(print);

// Request text events from the relay and subscribe to updates
final filter = Filter(
  kinds: [EventKind.text],
  limit: 10,
);
final subscriptionId = relay.subscribe(filter);

// Cancel the subscription
relay.unsubscribe(subscriptionId);

// Disconnect from the relay
relay.disconnect();
```

## Links

- [nostr-protocol][1]
- [awesome-nostr][2]



[1]: https://github.com/nostr-protocol
[2]: https://github.com/aljazceru/awesome-nostr

[nip01]: https://github.com/nostr-protocol/nips/blob/master/01.md
[nip02]: https://github.com/nostr-protocol/nips/blob/master/02.md
[nip03]: https://github.com/nostr-protocol/nips/blob/master/03.md
[nip04]: https://github.com/nostr-protocol/nips/blob/master/04.md
[nip05]: https://github.com/nostr-protocol/nips/blob/master/05.md
[nip06]: https://github.com/nostr-protocol/nips/blob/master/06.md
[nip07]: https://github.com/nostr-protocol/nips/blob/master/07.md
[nip08]: https://github.com/nostr-protocol/nips/blob/master/08.md
[nip09]: https://github.com/nostr-protocol/nips/blob/master/09.md
[nip10]: https://github.com/nostr-protocol/nips/blob/master/10.md
[nip11]: https://github.com/nostr-protocol/nips/blob/master/11.md
[nip12]: https://github.com/nostr-protocol/nips/blob/master/12.md
[nip13]: https://github.com/nostr-protocol/nips/blob/master/13.md
[nip14]: https://github.com/nostr-protocol/nips/blob/master/14.md
[nip15]: https://github.com/nostr-protocol/nips/blob/master/15.md
[nip16]: https://github.com/nostr-protocol/nips/blob/master/16.md
[nip20]: https://github.com/nostr-protocol/nips/blob/master/20.md
[nip22]: https://github.com/nostr-protocol/nips/blob/master/22.md
[nip25]: https://github.com/nostr-protocol/nips/blob/master/25.md
[nip28]: https://github.com/nostr-protocol/nips/blob/master/28.md
[nip35]: https://github.com/nostr-protocol/nips/blob/master/35.md
