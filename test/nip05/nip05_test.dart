import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:nostr_client/src/nip05.dart';
import 'package:nostr_client/src/nip05_service.dart';
import 'package:test/test.dart';

import '../utils.dart';

const validJackKey =
    '82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2';

class MockHttpClient extends Mock implements http.Client {}

class MockUri extends Mock implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late NIP05Service nip05Service;
  late Map<String, dynamic> eventData;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    nip05Service = NIP05Service(mockHttpClient);

    final event = await readEvent('event_0_jack');
    eventData = jsonDecode(event.content);
    registerFallbackValue(MockUri());
  });

  tearDown(() {
    mockHttpClient.close();
    eventData.clear();
  });

  void whenValidJack() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(
          jsonEncode({
            'names': {'jack': validJackKey}
          }),
          200),
    );
  }

  void whenInvalidJack() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(jsonEncode({'names': {}}), 200),
    );
  }

  void whenCached() => when(() => mockHttpClient.get(any()))
      .thenThrow(StateError('http.Client.get was called'));

  group('Nip05Service', () {
    group("get", () {
      test(("should return verified on valid data"), () async {
        whenValidJack();
        final res = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );

        expect(res.name, 'jack');
        expect(res.domain, 'cash.app');
        expect(res.verified, true);
      });

      test(("should return unverified invalid data"), () async {
        whenInvalidJack();
        final res = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );

        expect(res.name, 'jack');
        expect(res.domain, 'cash.app');
        expect(res.verified, false);
      });

      test('should throw ArgumentError in invalid key', () async {
        expect(
          () => nip05Service.get(
            'invalid key',
            eventData['nip05'],
            useCache: false,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
      test('should throw ArgumentError in invalid domain', () async {
        expect(
          () => nip05Service.get(
            validJackKey,
            'invalid address',
            useCache: false,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should use the cache and not call the remote endpoint', () async {
        whenValidJack();

        final fresh = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );

        whenCached();

        await Future.delayed(Duration(milliseconds: 200));

        final cached = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: true,
        );

        expect(fresh.hashCode, cached.hashCode);

        whenValidJack();

        final fresh2 = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );

        expect(fresh.hashCode, isNot(fresh2.hashCode));

        // the next call should return the new cached value
        final cached2 = await nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: true,
        );

        expect(fresh2.hashCode, cached2.hashCode);
      });
    });
    group('stream', () {
      test('should return broadcast stream', () async {
        expect(nip05Service.stream, isA<Stream<Nip05>>());
        expect(nip05Service.stream.isBroadcast, true);
      });

      test('should return stream with valid nip05', () async {
        whenValidJack();

        nip05Service.stream.listen((event) {
          expect(event.name, 'jack');
          expect(event.domain, 'cash.app');
          expect(event.verified, true);
        });

        nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );
      });

      test('should return stream with invalid nip05', () async {
        whenInvalidJack();

        nip05Service.stream.listen((event) {
          expect(event.name, 'jack');
          expect(event.domain, 'cash.app');
          expect(event.verified, false);
        });

        nip05Service.get(
          validJackKey,
          eventData['nip05'],
          useCache: false,
        );
      });
    });
  });
}
