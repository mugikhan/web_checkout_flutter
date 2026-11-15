import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:api/src/data/graphql/auth.graphql.dart';
import 'package:api/src/data/graphql/checkout.graphql.dart';
import 'package:api/src/data/graphql/orders.graphql.dart';
import 'package:api/src/data/graphql/schema.graphql.dart';

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  late MemoryStore store;
  late LocalServer server;
  late DateTime now;
  late List<Duration> delays;
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

  Future<String> placeOrder(String cardId) async {
    final sessionId = Mutation$CreateCheckoutSession.fromJson(
      await call('CreateCheckoutSession', naledi),
    ).createCheckoutSession.id;
    await call('SetPaymentMethod', naledi, {
      'sessionId': sessionId,
      'cardId': cardId,
    });
    final result = Mutation$ConfirmCheckout.fromJson(
      await call('ConfirmCheckout', naledi, {
        'sessionId': sessionId,
        'bagIds': ['bag_cafe', 'bag_bakery'],
        'slotStart': slot.start.toIso8601String(),
      }),
    ).confirmCheckout;
    return (result as Mutation$ConfirmCheckout$confirmCheckout$$Order).id;
  }

  Future<Query$Order$order> read(String id, [RequestContext? context]) async =>
      Query$Order.fromJson(await call('Order', context ?? naledi, {'id': id}))
          .order;

  Future<Fragment$OrderFields> order(String id) async =>
      (await read(id)) as Fragment$OrderFields;

  Future<List<Subscription$OrderStatusChanged$orderStatusChanged>> follow(
    String id, [
    RequestContext? context,
  ]) => server
      .streams['OrderStatusChanged']!({'orderId': id}, context ?? naledi)
      .map((json) {
        return Subscription$OrderStatusChanged.fromJson(json)
            .orderStatusChanged;
      })
      .toList();

  setUp(() async {
    now = DateTime.utc(2026, 11, 15, 10, 30);
    delays = [];
    slot = CollectionWindow.offered(now).first;
    store = MemoryStore();
    server = LocalServer(
      store,
      clock: () => now,
      delay: (duration) async => delays.add(duration),
    );
    naledi = await signIn('Naledi');
    thabo = await signIn('Thabo');
  });

  group('order', () {
    test(
      'returns the stored details with the prices at confirm time',
      () async {
        final id = await placeOrder('card_visa_4242');

        final result = await order(id);

        expect(result.store, 'Corner Pantry');
        expect(result.bags.map((b) => (b.name, b.priceCents)), [
          ('Café bag', 5999),
          ('Bakery bag', 4999),
        ]);
        expect(result.totalCents, 10998);
        expect(result.window.startsAt, slot.start.toIso8601String());
        expect(result.card.brand, 'Visa');
        expect(result.card.last4, '4242');
        expect(result.createdAt, '2026-11-15T10:30:00.000Z');
        expect(result.holdConfirmsAt, '2026-11-15T10:30:03.000Z');
      },
    );

    test(
      'prices stay as confirmed: stored prices win over the catalog',
      () async {
        final id = await placeOrder('card_visa_4242');
        final orders =
            jsonDecode((await store.read('orders'))!) as Map<String, dynamic>;
        final stored = orders[id] as Map<String, dynamic>;
        stored['bags'] = [
          {'id': 'bag_cafe', 'name': 'Café bag', 'priceCents': 4500},
          {'id': 'bag_bakery', 'name': 'Bakery bag', 'priceCents': 3000},
        ];
        stored['totalCents'] = 7500;
        await store.write('orders', jsonEncode(orders));

        final result = await order(id);

        expect(result.bags.map((b) => b.priceCents), [4500, 3000]);
        expect(result.totalCents, 7500);
      },
    );

    test('is Pending before the hold time', () async {
      final id = await placeOrder('card_visa_4242');
      now = now.add(const Duration(milliseconds: 2999));

      expect((await order(id)).status, Enum$OrderStatus.PENDING);
    });

    test('is Confirmed at the hold time for the Visa card', () async {
      final id = await placeOrder('card_visa_4242');
      now = now.add(const Duration(seconds: 3));

      expect((await order(id)).status, Enum$OrderStatus.CONFIRMED);
    });

    test('is Failed at the hold time for the Mastercard', () async {
      final id = await placeOrder('card_mastercard_0002');
      now = now.add(const Duration(seconds: 3));

      expect((await order(id)).status, Enum$OrderStatus.FAILED);
    });

    test('reads an unknown id as not found', () async {
      final result = await read('ord_missing');

      expect(result, isA<Query$Order$order$$OrderNotFound>());
      expect(
        (result as Query$Order$order$$OrderNotFound).orderId,
        'ord_missing',
      );
    });

    test('reads another viewer\'s order as not found', () async {
      final id = await placeOrder('card_visa_4242');

      expect(await read(id, thabo), isA<Query$Order$order$$OrderNotFound>());
      expect(
        await read(id, const RequestContext()),
        isA<Query$Order$order$$OrderNotFound>(),
      );
    });
  });

  group('orderStatusChanged', () {
    test('emits Pending, then the settled order at the hold time', () async {
      final id = await placeOrder('card_visa_4242');
      now = now.add(const Duration(seconds: 1));

      final events = await follow(id);

      expect(events.map((e) => (e as Fragment$OrderFields).status), [
        Enum$OrderStatus.PENDING,
        Enum$OrderStatus.CONFIRMED,
      ]);
      expect(delays, [const Duration(seconds: 2)]);
    });

    test('settles a Mastercard order to Failed', () async {
      final id = await placeOrder('card_mastercard_0002');

      final events = await follow(id);

      expect(events.map((e) => (e as Fragment$OrderFields).status), [
        Enum$OrderStatus.PENDING,
        Enum$OrderStatus.FAILED,
      ]);
    });

    test(
      'emits the settled order once, with no wait, after the hold',
      () async {
        final id = await placeOrder('card_visa_4242');
        now = now.add(const Duration(seconds: 5));

        final events = await follow(id);

        expect(events.map((e) => (e as Fragment$OrderFields).status), [
          Enum$OrderStatus.CONFIRMED,
        ]);
        expect(delays, isEmpty);
      },
    );

    test('emits not found once for an unknown or foreign order', () async {
      final id = await placeOrder('card_visa_4242');

      expect(await follow('ord_missing'), hasLength(1));
      final foreign = await follow(id, thabo);
      expect(foreign, hasLength(1));
      expect(
        foreign.single,
        isA<
          Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound
        >(),
      );
      expect(delays, isEmpty);
    });
  });
}
