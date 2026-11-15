import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';

void main() {
  late MockCheckoutRepository repository;

  setUp(() => repository = MockCheckoutRepository());

  CheckoutStartBloc build() =>
      CheckoutStartBloc(checkoutRepository: repository);

  const started = CheckoutStartState(
    status: CheckoutStartStatus.started,
    sessionId: 'cs_1',
  );
  const failed = CheckoutStartState(status: CheckoutStartStatus.failed);

  blocTest<CheckoutStartBloc, CheckoutStartState>(
    'a start creates a session',
    setUp: () =>
        when(() => repository.createSession())
            .thenAnswer((_) async => const CheckoutStarted('cs_1')),
    build: build,
    act: (bloc) => bloc.add(const CheckoutStartRequested()),
    expect: () => [const CheckoutStartState(), started],
  );

  blocTest<CheckoutStartBloc, CheckoutStartState>(
    'a failed start shows the failure and a retry starts again',
    setUp: () =>
        when(() => repository.createSession())
            .thenAnswer((_) async => const CheckoutUnavailable()),
    build: build,
    act: (bloc) async {
      bloc.add(const CheckoutStartRequested());
      await Future<void>.delayed(Duration.zero);
      when(() => repository.createSession())
          .thenAnswer((_) async => const CheckoutStarted('cs_1'));
      bloc.add(const CheckoutStartRequested());
    },
    expect: () => [
      const CheckoutStartState(),
      failed,
      const CheckoutStartState(),
      started,
    ],
  );

  final pending = Completer<StartCheckoutResult>();
  blocTest<CheckoutStartBloc, CheckoutStartState>(
    'a second start while one runs is dropped',
    setUp: () =>
        when(() => repository.createSession())
            .thenAnswer((_) => pending.future),
    build: build,
    act: (bloc) async {
      bloc
        ..add(const CheckoutStartRequested())
        ..add(const CheckoutStartRequested());
      await Future<void>.delayed(Duration.zero);
      pending.complete(const CheckoutStarted('cs_1'));
    },
    expect: () => [const CheckoutStartState(), started],
    verify: (_) => verify(() => repository.createSession()).called(1),
  );
}
