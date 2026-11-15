import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders/orders.dart';

import 'support/fixtures.dart';

void main() {
  late MockOrderRepository repository;
  late StreamController<OrderResult> updates;

  setUp(() {
    repository = MockOrderRepository();
    updates = StreamController<OrderResult>();
    when(() => repository.watchStatus('ord_1'))
        .thenAnswer((_) => updates.stream);
  });

  // close() waits for a listener, so do not await it.
  tearDown(() => unawaited(updates.close()));

  OrderBloc build() => OrderBloc(orderRepository: repository);

  void answer(OrderResult result) =>
      when(() => repository.order('ord_1')).thenAnswer((_) async => result);

  OrderState loaded(Order order) => OrderState(
    status: OrderLoadStatus.loaded,
    orderId: 'ord_1',
    order: order,
  );

  const loading = OrderState(orderId: 'ord_1');

  blocTest<OrderBloc, OrderState>(
    'follows a pending order to Confirmed',
    setUp: () => answer(OrderLoaded(pending)),
    build: build,
    act: (bloc) async {
      bloc.add(const OrderLoadRequested('ord_1'));
      await pumpEventQueue();
      updates
        ..add(OrderLoaded(pending))
        ..add(OrderLoaded(confirmed));
      await pumpEventQueue();
    },
    expect: () => [loading, loaded(pending), loaded(confirmed)],
    verify: (_) => verify(() => repository.watchStatus('ord_1')).called(1),
  );

  blocTest<OrderBloc, OrderState>(
    'follows a pending order to Failed',
    setUp: () => answer(OrderLoaded(pending)),
    build: build,
    act: (bloc) async {
      bloc.add(const OrderLoadRequested('ord_1'));
      await pumpEventQueue();
      updates.add(OrderLoaded(failed));
      await pumpEventQueue();
    },
    expect: () => [loading, loaded(pending), loaded(failed)],
  );

  blocTest<OrderBloc, OrderState>(
    'a settled order opens without a subscription',
    setUp: () => answer(OrderLoaded(confirmed)),
    build: build,
    act: (bloc) => bloc.add(const OrderLoadRequested('ord_1')),
    expect: () => [loading, loaded(confirmed)],
    verify: (_) => verifyNever(() => repository.watchStatus(any())),
  );

  blocTest<OrderBloc, OrderState>(
    'an unknown order is not found, with no subscription',
    setUp: () => answer(const OrderNotFound()),
    build: build,
    act: (bloc) => bloc.add(const OrderLoadRequested('ord_1')),
    expect: () => [
      loading,
      const OrderState(status: OrderLoadStatus.notFound, orderId: 'ord_1'),
    ],
    verify: (_) => verifyNever(() => repository.watchStatus(any())),
  );

  blocTest<OrderBloc, OrderState>(
    'an unavailable order fails, and a retry loads it',
    setUp: () {
      var calls = 0;
      when(() => repository.order('ord_1')).thenAnswer(
        (_) async =>
            ++calls == 1 ? const OrderUnavailable() : OrderLoaded(confirmed),
      );
    },
    build: build,
    act: (bloc) async {
      bloc.add(const OrderLoadRequested('ord_1'));
      await pumpEventQueue();
      bloc.add(const OrderLoadRequested('ord_1'));
    },
    expect: () => [
      loading,
      const OrderState(status: OrderLoadStatus.failed, orderId: 'ord_1'),
      loading,
      loaded(confirmed),
    ],
  );

  blocTest<OrderBloc, OrderState>(
    'a failing subscription shows the failed state',
    setUp: () => answer(OrderLoaded(pending)),
    build: build,
    act: (bloc) async {
      bloc.add(const OrderLoadRequested('ord_1'));
      await pumpEventQueue();
      updates.add(const OrderUnavailable());
    },
    expect: () => [
      loading,
      loaded(pending),
      const OrderState(status: OrderLoadStatus.failed, orderId: 'ord_1'),
    ],
  );

  test('closing the bloc cancels the subscription', () async {
    answer(OrderLoaded(pending));
    final bloc = build()..add(const OrderLoadRequested('ord_1'));
    await pumpEventQueue();
    expect(updates.hasListener, isTrue);

    await bloc.close();

    expect(updates.hasListener, isFalse);
  });
}
