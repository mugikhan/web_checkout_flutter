import 'dart:convert';

import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:api/src/data/graphql/auth.graphql.dart';
import 'package:api/src/data/graphql/checkout.graphql.dart';
import 'package:api/src/data/graphql/schema.graphql.dart';
import 'package:api/src/data/server/checkout_resolvers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  late MemoryStore store;
  late LocalServer server;
  late DateTime now;
  late RequestContext naledi;
  late RequestContext thabo;
  late CollectionWindow slot;

  Future<Map<String, dynamic>> call(
    String operation,
    RequestContext context, [
    Map<String, dynamic> variables = const {},
  ]) => server.resolvers[operation]!(variables, context);

  Future<RequestContext> signIn(String name) async {
    final result = Mutation$SignIn.fromJson(
      await call('SignIn', const RequestContext(), {'name': name}),
    );
    final success = result.signIn as Mutation$SignIn$signIn$$SignInSuccess;
    return RequestContext(token: success.token);
  }

  Future<String> create([RequestContext? context]) async =>
      Mutation$CreateCheckoutSession.fromJson(
        await call('CreateCheckoutSession', context ?? naledi),
      ).createCheckoutSession.id;

  Future<Query$CheckoutSession> read(
    String id, [
    RequestContext? context,
  ]) async => Query$CheckoutSession.fromJson(
    await call('CheckoutSession', context ?? naledi, {'id': id}),
  );

  Future<Fragment$CheckoutSessionFields> session(String id) async =>
      (await read(id)).checkoutSession as Fragment$CheckoutSessionFields;

  Future<Mutation$SetPaymentMethod$setPaymentMethod> setCard(
    String sessionId,
    String cardId, [
    RequestContext? context,
  ]) async => Mutation$SetPaymentMethod.fromJson(
    await call('SetPaymentMethod', context ?? naledi, {
      'sessionId': sessionId,
      'cardId': cardId,
    }),
  ).setPaymentMethod;

  Future<Mutation$ConfirmCheckout$confirmCheckout> confirm(
    String sessionId, {
    List<String> bagIds = const ['bag_cafe', 'bag_bakery'],
    String? slotStart,
    RequestContext? context,
  }) async => Mutation$ConfirmCheckout.fromJson(
    await call('ConfirmCheckout', context ?? naledi, {
      'sessionId': sessionId,
      'bagIds': bagIds,
      'slotStart': slotStart ?? slot.start.toIso8601String(),
    }),
  ).confirmCheckout;

  Future<Map<String, dynamic>> orders() async {
    final raw = await store.read('orders');
    return raw == null ? {} : jsonDecode(raw) as Map<String, dynamic>;
  }

  setUp(() async {
    store = MemoryStore();
    now = DateTime.utc(2026, 11, 15, 10, 30);
    slot = CollectionWindow.offered(now).first;
    server = LocalServer(store, clock: () => now);
    naledi = await signIn('Naledi');
    thabo = await signIn('Thabo');
  });

  group('createCheckoutSession', () {
    test('stores an open session owned by the viewer', () async {
      final id = await create();

      expect(id, startsWith('cs_'));
      final result = await session(id);
      expect(result.status, Enum$CheckoutSessionStatus.OPEN);
      expect(result.expiresAt, '2026-11-15T10:45:00.000Z');
      expect(result.orderId, isNull);
      expect(result.paymentMethod, isNull);
      expect(result.collectionWindows, isNotEmpty);
    });

    test('fails without a viewer', () async {
      expect(
        () => call('CreateCheckoutSession', const RequestContext()),
        throwsStateError,
      );
    });
  });

  group('checkoutSession', () {
    test('offers the windows that start after now, in UTC', () async {
      final id = await create();

      final windows = (await session(id)).collectionWindows;
      final starts = windows.map((w) => DateTime.parse(w.startsAt));
      expect(starts.every((s) => s.isUtc && s.isAfter(now)), isTrue);
      expect(
        DateTime.parse(windows.first.endsAt).difference(starts.first),
        const Duration(hours: 1),
      );
    });

    test('returns both saved cards for a viewer', () async {
      final result = await read(await create());

      expect(result.savedCards.map((c) => (c.id, c.brand, c.last4)), [
        ('card_visa_4242', 'Visa', '4242'),
        ('card_mastercard_0002', 'Mastercard', '0002'),
      ]);
    });

    test('is expired 15 minutes after creation, with no windows', () async {
      final id = await create();
      now = now.add(const Duration(minutes: 14, seconds: 59));
      expect((await session(id)).status, Enum$CheckoutSessionStatus.OPEN);

      now = now.add(const Duration(seconds: 1));
      final result = await session(id);
      expect(result.status, Enum$CheckoutSessionStatus.EXPIRED);
      expect(result.collectionWindows, isEmpty);
    });

    test('reads an unknown session as not found', () async {
      final result = await read('cs_unknown');

      expect(
        result.checkoutSession,
        isA<Query$CheckoutSession$checkoutSession$$SessionNotFound>(),
      );
    });

    test('reads another viewer\'s session as not found', () async {
      final id = await create();

      final result = await read(id, thabo);

      expect(
        result.checkoutSession,
        isA<Query$CheckoutSession$checkoutSession$$SessionNotFound>(),
      );
    });

    test('without a viewer reads not found and no cards', () async {
      final id = await create();

      final result = await read(id, const RequestContext());

      expect(
        result.checkoutSession,
        isA<Query$CheckoutSession$checkoutSession$$SessionNotFound>(),
      );
      expect(result.savedCards, isEmpty);
    });
  });

  group('setPaymentMethod', () {
    test('stores the card on the session', () async {
      final id = await create();

      final result = await setCard(id, 'card_visa_4242');

      final fields = result as Fragment$CheckoutSessionFields;
      expect(fields.paymentMethod?.id, 'card_visa_4242');
      expect((await session(id)).paymentMethod?.last4, '4242');
    });

    test('the last card set wins', () async {
      final id = await create();

      await Future.wait([
        setCard(id, 'card_visa_4242'),
        setCard(id, 'card_mastercard_0002'),
      ]);

      expect((await session(id)).paymentMethod?.id, 'card_mastercard_0002');
    });

    test('rejects an unknown card and leaves the session', () async {
      final id = await create();
      await setCard(id, 'card_visa_4242');

      final result = await setCard(id, 'card_forged');

      expect(
        result,
        isA<Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound>(),
      );
      expect((await session(id)).paymentMethod?.id, 'card_visa_4242');
    });

    test('rejects an unknown or foreign session', () async {
      final id = await create();

      expect(
        await setCard('cs_unknown', 'card_visa_4242'),
        isA<Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound>(),
      );
      expect(
        await setCard(id, 'card_visa_4242', thabo),
        isA<Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound>(),
      );
    });

    test('rejects an expired session', () async {
      final id = await create();
      now = now.add(CheckoutResolvers.sessionLength);

      expect(
        await setCard(id, 'card_visa_4242'),
        isA<Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired>(),
      );
    });

    test('leaves a completed session unchanged', () async {
      final id = await create();
      await setCard(id, 'card_visa_4242');
      await confirm(id);

      final result = await setCard(id, 'card_mastercard_0002');

      final fields = result as Fragment$CheckoutSessionFields;
      expect(fields.status, Enum$CheckoutSessionStatus.COMPLETED);
      expect(fields.paymentMethod?.id, 'card_visa_4242');
    });
  });

  group('confirmCheckout', () {
    late String id;

    setUp(() async {
      id = await create();
      await setCard(id, 'card_visa_4242');
    });

    test('creates one order and completes the session', () async {
      final result = await confirm(id);

      final order = result as Mutation$ConfirmCheckout$confirmCheckout$$Order;
      expect(order.id, startsWith('ord_'));
      expect(order.status, Enum$OrderStatus.CREATED);
      final fields = await session(id);
      expect(fields.status, Enum$CheckoutSessionStatus.COMPLETED);
      expect(fields.orderId, order.id);
      expect((await orders()).keys, [order.id]);
    });

    test('a repeat returns the existing order, even with other args', () async {
      final first = await confirm(id);

      final second = await confirm(id, bagIds: ['bag_grocery']);

      expect(
        (second as Mutation$ConfirmCheckout$confirmCheckout$$Order).id,
        (first as Mutation$ConfirmCheckout$confirmCheckout$$Order).id,
      );
      expect(await orders(), hasLength(1));
    });

    test('two confirms at once create one order', () async {
      final results = await Future.wait([confirm(id), confirm(id)]);

      final ids = results
          .cast<Mutation$ConfirmCheckout$confirmCheckout$$Order>()
          .map((o) => o.id)
          .toSet();
      expect(ids, hasLength(1));
      expect(await orders(), hasLength(1));
    });

    test(
      'records snapshot prices, the window, the card and the hold',
      () async {
        final order = await confirm(
          id,
        ) as Mutation$ConfirmCheckout$confirmCheckout$$Order;

        final record = (await orders())[order.id] as Map<String, dynamic>;
        expect(record['ownerId'], 'viewer:naledi');
        expect(record['sessionId'], id);
        expect(record['status'], 'CREATED');
        expect(record['store'], 'Corner Pantry');
        expect(record['bags'], [
          {'id': 'bag_cafe', 'name': 'Café bag', 'priceCents': 5999},
          {'id': 'bag_bakery', 'name': 'Bakery bag', 'priceCents': 4999},
        ]);
        expect(record['totalCents'], 10998);
        expect(record['window'], {
          'startsAt': slot.start.toIso8601String(),
          'endsAt': slot.end.toIso8601String(),
        });
        expect(record['paymentMethod'], {
          'id': 'card_visa_4242',
          'brand': 'Visa',
          'last4': '4242',
        });
        expect(record['createdAt'], '2026-11-15T10:30:00.000Z');
        expect(record['holdConfirmsAt'], '2026-11-15T10:30:03.000Z');
        expect(record['declines'], isFalse);
      },
    );

    test('records that the Mastercard declines', () async {
      await setCard(id, 'card_mastercard_0002');

      final order =
          await confirm(id) as Mutation$ConfirmCheckout$confirmCheckout$$Order;

      expect(
        ((await orders())[order.id] as Map<String, dynamic>)['declines'],
        isTrue,
      );
    });

    test('accepts the compact slot form', () async {
      expect(
        await confirm(id, slotStart: slot.slotParam),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$Order>(),
      );
    });

    test('rejects an unknown or foreign session', () async {
      expect(
        await confirm('cs_unknown'),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound>(),
      );
      expect(
        await confirm(id, context: thabo),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound>(),
      );
      expect(await orders(), isEmpty);
    });

    test('rejects an expired session', () async {
      now = now.add(CheckoutResolvers.sessionLength);

      expect(
        await confirm(id),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired>(),
      );
      expect(await orders(), isEmpty);
    });

    for (final bagIds in [
      <String>[],
      ['bag_cafe', 'bag_bakery', 'bag_grocery'],
      ['bag_cafe', 'bag_cafe'],
      ['bag_unknown'],
    ]) {
      test('rejects the bags $bagIds', () async {
        final result = await confirm(id, bagIds: bagIds);

        expect(
          (result as Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags)
              .maxBags,
          2,
        );
        expect(await orders(), isEmpty);
      });
    }

    for (final (label, slotStart) in [
      ('an hour before now', () => now.subtract(const Duration(hours: 1))),
      ('off the hour', () => slot.start.add(const Duration(minutes: 30))),
      ('in 5 days', () => slot.start.add(const Duration(days: 5))),
    ]) {
      test('rejects a slot $label', () async {
        expect(
          await confirm(id, slotStart: slotStart().toIso8601String()),
          isA<Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable>(),
        );
        expect(await orders(), isEmpty);
      });
    }

    test('rejects a slot that is not an instant', () async {
      expect(
        await confirm(id, slotStart: 'noon'),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable>(),
      );
    });

    test('rejects a slot that started while the session was open', () async {
      now = slot.start.subtract(const Duration(minutes: 5));
      final fresh = await create();
      await setCard(fresh, 'card_visa_4242');
      now = slot.start;

      expect(
        await confirm(fresh),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable>(),
      );
    });
    test('rejects a session with no payment method', () async {
      final bare = await create();

      expect(
        await confirm(bare),
        isA<Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing>(),
      );
      expect(await orders(), isEmpty);
    });
  });

  test(
    'sessions and orders survive a new server over the same store',
    () async {
      final id = await create();
      await setCard(id, 'card_visa_4242');
      final order =
          await confirm(id) as Mutation$ConfirmCheckout$confirmCheckout$$Order;

      server = LocalServer(store, clock: () => now);

      expect((await session(id)).orderId, order.id);
    },
  );
}
