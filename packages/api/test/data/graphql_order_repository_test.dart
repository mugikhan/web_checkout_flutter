import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart' hide Store;
import 'package:storage/storage.dart';

void main() {
  late DateTime now;
  late CheckoutRepository checkout;
  late OrderRepository repository;
  late CollectionWindow slot;

  setUp(() async {
    now = DateTime.utc(2026, 11, 15, 10, 30);
    slot = CollectionWindow.offered(now).first;
    final tokens = TokenStore(MemoryStore());
    final client = buildGraphqlClient(
      tokens: tokens,
      server: LocalServer(
        MemoryStore(),
        clock: () => now,
        delay: (duration) async => now = now.add(duration),
      ),
    );
    await GraphqlAuthRepository(
      client: client,
      tokens: tokens,
    ).signIn('Naledi');
    checkout = GraphqlCheckoutRepository(client: client);
    repository = GraphqlOrderRepository(client: client);
  });

  Future<String> place(String cardId) async {
    final sessionId =
        (await checkout.createSession() as CheckoutStarted).sessionId;
    await checkout.setPaymentMethod(sessionId, cardId);
    final result = await checkout.confirm(sessionId, [
      'bag_cafe',
      'bag_bakery',
    ], slot.start);
    return (result as CheckoutConfirmed).orderId;
  }

  test('order maps the details of a pending order', () async {
    final id = await place('card_visa_4242');

    final result = await repository.order(id) as OrderLoaded;

    expect(result.order.id, id);
    expect(result.order.status, OrderStatus.pending);
    expect(result.order.store, 'Corner Pantry');
    expect(result.order.bags, const [
      OrderBag(id: 'bag_cafe', name: 'Café bag', price: Money(5999)),
      OrderBag(id: 'bag_bakery', name: 'Bakery bag', price: Money(4999)),
    ]);
    expect(result.order.total, const Money(10998));
    expect(result.order.window.start, slot.start);
    expect(result.order.card, const OrderCard(brand: 'Visa', last4: '4242'));
    expect(result.order.createdAt, DateTime.utc(2026, 11, 15, 10, 30));
    expect(result.order.holdConfirmsAt, DateTime.utc(2026, 11, 15, 10, 30, 3));
  });

  test('order maps a settled order', () async {
    final visa = await place('card_visa_4242');
    final mastercard = await place('card_mastercard_0002');
    now = now.add(const Duration(seconds: 3));

    expect(
      (await repository.order(visa) as OrderLoaded).order.status,
      OrderStatus.confirmed,
    );
    expect(
      (await repository.order(mastercard) as OrderLoaded).order.status,
      OrderStatus.failed,
    );
  });

  test('order maps an unknown id to OrderNotFound', () async {
    expect(await repository.order('ord_missing'), const OrderNotFound());
  });

  test('watchStatus emits Pending, then Confirmed', () async {
    final id = await place('card_visa_4242');

    final results = await repository.watchStatus(id).toList();

    expect(results.map((r) => (r as OrderLoaded).order.status), [
      OrderStatus.pending,
      OrderStatus.confirmed,
    ]);
  });

  test('watchStatus emits Pending, then Failed', () async {
    final id = await place('card_mastercard_0002');

    final results = await repository.watchStatus(id).toList();

    expect(results.map((r) => (r as OrderLoaded).order.status), [
      OrderStatus.pending,
      OrderStatus.failed,
    ]);
  });

  test('watchStatus maps an unknown id to one OrderNotFound', () async {
    expect(await repository.watchStatus('ord_missing').toList(), const [
      OrderNotFound(),
    ]);
  });

  group('over a broken link', () {
    final broken = GraphqlOrderRepository(
      client: GraphQLClient(link: LocalLink({}), cache: GraphQLCache()),
    );

    test('every call maps to OrderUnavailable', () async {
      expect(await broken.order('ord_1'), const OrderUnavailable());
      expect(await broken.watchStatus('ord_1').toList(), const [
        OrderUnavailable(),
      ]);
    });
  });
}
