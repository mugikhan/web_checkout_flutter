import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart' hide Store;
import 'package:storage/storage.dart';

void main() {
  late DateTime now;
  late CheckoutRepository repository;
  late CollectionWindow slot;

  setUp(() async {
    now = DateTime.utc(2026, 11, 15, 10, 30);
    slot = CollectionWindow.offered(now).first;
    final tokens = TokenStore(MemoryStore());
    final client = buildGraphqlClient(
      tokens: tokens,
      server: LocalServer(MemoryStore(), clock: () => now),
    );
    await GraphqlAuthRepository(
      client: client,
      tokens: tokens,
    ).signIn('Naledi');
    repository = GraphqlCheckoutRepository(client: client);
  });

  Future<String> start() async =>
      (await repository.createSession() as CheckoutStarted).sessionId;

  test('createSession and session map an open session with cards', () async {
    final id = await start();

    final result = await repository.session(id) as CheckoutSessionLoaded;

    expect(result.session.id, id);
    expect(result.session.status, CheckoutSessionStatus.open);
    expect(result.session.expiresAt, DateTime.utc(2026, 11, 15, 10, 45));
    expect(result.session.paymentMethod, isNull);
    expect(result.session.windows, CollectionWindow.offered(now));
    expect(result.savedCards, const [
      SavedCard(id: 'card_visa_4242', brand: 'Visa', last4: '4242'),
      SavedCard(id: 'card_mastercard_0002', brand: 'Mastercard', last4: '0002'),
    ]);
  });

  test('session maps an expired session', () async {
    final id = await start();
    now = now.add(const Duration(minutes: 15));

    final result = await repository.session(id) as CheckoutSessionLoaded;

    expect(result.session.status, CheckoutSessionStatus.expired);
    expect(result.session.windows, isEmpty);
  });

  test('session maps an unknown id to SessionNotFound', () async {
    expect(await repository.session('cs_unknown'), const SessionNotFound());
  });

  test('setPaymentMethod maps each result', () async {
    final id = await start();

    final set = await repository.setPaymentMethod(
      id,
      'card_visa_4242',
    ) as PaymentMethodSet;
    expect(set.session.paymentMethod?.last4, '4242');
    expect(
      await repository.setPaymentMethod(id, 'card_forged'),
      const CardNotFound(),
    );
    expect(
      await repository.setPaymentMethod('cs_unknown', 'card_visa_4242'),
      const SessionNotFound(),
    );
    now = now.add(const Duration(minutes: 15));
    expect(
      await repository.setPaymentMethod(id, 'card_visa_4242'),
      const SessionExpired(),
    );
  });

  test('confirm returns the order and repeats return the same one', () async {
    final id = await start();
    await repository.setPaymentMethod(id, 'card_visa_4242');

    final first = await repository.confirm(id, ['bag_cafe'], slot.start);
    final again = await repository.confirm(id, ['bag_cafe'], slot.start);

    expect(first, isA<CheckoutConfirmed>());
    expect(again, first);
    final session = await repository.session(id) as CheckoutSessionLoaded;
    expect(session.session.status, CheckoutSessionStatus.completed);
    expect(session.session.orderId, (first as CheckoutConfirmed).orderId);
  });

  test('confirm maps each failure', () async {
    final id = await start();

    expect(
      await repository.confirm(id, ['bag_cafe'], slot.start),
      const PaymentMethodMissing(),
    );
    await repository.setPaymentMethod(id, 'card_visa_4242');
    expect(await repository.confirm(id, [], slot.start), const InvalidBags());
    expect(
      await repository.confirm(id, [
        'bag_cafe',
      ], slot.start.add(const Duration(minutes: 30))),
      const SlotUnavailable(),
    );
    expect(
      await repository.confirm('cs_unknown', ['bag_cafe'], slot.start),
      const SessionNotFound(),
    );
    now = now.add(const Duration(minutes: 15));
    expect(
      await repository.confirm(id, ['bag_cafe'], slot.start),
      const SessionExpired(),
    );
  });

  group('over a broken link', () {
    final broken = GraphqlCheckoutRepository(
      client: GraphQLClient(link: LocalLink({}), cache: GraphQLCache()),
    );

    test('every call maps to CheckoutUnavailable', () async {
      expect(await broken.createSession(), const CheckoutUnavailable());
      expect(await broken.session('cs_1'), const CheckoutUnavailable());
      expect(
        await broken.setPaymentMethod('cs_1', 'card_visa_4242'),
        const CheckoutUnavailable(),
      );
      expect(
        await broken.confirm('cs_1', ['bag_cafe'], slot.start),
        const CheckoutUnavailable(),
      );
    });
  });

  test('createSession without a viewer maps to CheckoutUnavailable', () async {
    final signedOut = GraphqlCheckoutRepository(
      client: buildGraphqlClient(
        tokens: TokenStore(MemoryStore()),
        server: LocalServer(MemoryStore()),
      ),
    );

    expect(await signedOut.createSession(), const CheckoutUnavailable());
  });
}
