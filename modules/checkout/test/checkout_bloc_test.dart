import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';

void main() {
  late MockCheckoutRepository checkout;
  late MockCatalogRepository catalog;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    checkout = MockCheckoutRepository();
    catalog = MockCatalogRepository();
    when(() => catalog.bags())
        .thenAnswer((_) async => const BagsLoaded(allBags));
  });

  CheckoutBloc build() => CheckoutBloc(
    checkoutRepository: checkout,
    catalogRepository: catalog,
    clock: () => now,
  );

  void answerSession(CheckoutSessionResult result) =>
      when(() => checkout.session('cs_1')).thenAnswer((_) async => result);

  final today = DateTime(2026, 11, 15);

  CheckoutState loaded({
    List<String> linkIds = const ['bag_cafe'],
    String? linkSlot,
    SavedCard? card,
  }) {
    final window = windows.where((w) => w.slotParam == linkSlot).firstOrNull;
    return CheckoutState(
      status: CheckoutStatus.ready,
      sessionId: 'cs_1',
      bags: allBags,
      savedCards: savedCards,
      windows: windows,
      today: today,
      linkIds: linkIds,
      linkSlot: linkSlot,
      picked: linkIds,
      window: window,
      cardId: card?.id,
    );
  }

  final ready = loaded(linkSlot: firstWindow.slotParam, card: visa);

  group('load', () {
    blocTest<CheckoutBloc, CheckoutState>(
      'an open session shows the bags, windows and cards',
      setUp: () =>
          answerSession(CheckoutSessionLoaded(openSession(), savedCards)),
      build: build,
      act: (bloc) => bloc
        ..add(CheckoutLinkChanged(const ['bag_cafe'], firstWindow.slotParam))
        ..add(const CheckoutLoadRequested('cs_1')),
      skip: 2,
      expect: () => [loaded(linkSlot: firstWindow.slotParam)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an open session with a stored card shows it picked',
      setUp: () => answerSession(
        CheckoutSessionLoaded(openSession(card: visa), savedCards),
      ),
      build: build,
      seed: () => const CheckoutState(linkIds: ['bag_cafe']),
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      skip: 1,
      expect: () => [loaded(card: visa)],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a completed session carries its order id',
      setUp: () =>
          answerSession(CheckoutSessionLoaded(completedSession, savedCards)),
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) {
        expect(bloc.state.status, CheckoutStatus.completed);
        expect(bloc.state.orderId, 'ord_1');
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a completed session redirects even when the bags fail',
      setUp: () {
        answerSession(CheckoutSessionLoaded(completedSession, savedCards));
        when(() => catalog.bags())
            .thenAnswer((_) async => const BagsUnavailable());
      },
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) => expect(bloc.state.orderId, 'ord_1'),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an expired session shows expired',
      setUp: () =>
          answerSession(CheckoutSessionLoaded(expiredSession, savedCards)),
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.expired),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an unknown session shows not found',
      setUp: () => answerSession(const SessionNotFound()),
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.notFound),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a session fault shows the failure',
      setUp: () => answerSession(const CheckoutUnavailable()),
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.failed),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a bags fault on an open session shows the failure',
      setUp: () {
        answerSession(CheckoutSessionLoaded(openSession(), savedCards));
        when(() => catalog.bags())
            .thenAnswer((_) async => const BagsUnavailable());
      },
      build: build,
      act: (bloc) => bloc.add(const CheckoutLoadRequested('cs_1')),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.failed),
    );

    final first = Completer<CheckoutSessionResult>();
    final second = Completer<CheckoutSessionResult>();
    blocTest<CheckoutBloc, CheckoutState>(
      'a new load restarts a running one, so the last result wins',
      setUp: () {
        final answers = [first, second];
        when(() => checkout.session('cs_1'))
            .thenAnswer((_) => answers.removeAt(0).future);
      },
      build: build,
      act: (bloc) async {
        bloc
          ..add(const CheckoutLoadRequested('cs_1'))
          ..add(const CheckoutLoadRequested('cs_1'));
        await Future<void>.delayed(Duration.zero);
        first.complete(const SessionNotFound());
        second.complete(CheckoutSessionLoaded(openSession(), savedCards));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.ready),
    );
  });

  group('link', () {
    blocTest<CheckoutBloc, CheckoutState>(
      'bad bags are cleaned and the URL needs cleaning',
      build: build,
      seed: () => loaded(),
      act: (bloc) => bloc.add(
        const CheckoutLinkChanged([
          'bag_unknown',
          'bag_cafe',
          'bag_cafe',
          'bag_bakery',
          'bag_grocery',
        ], null),
      ),
      verify: (bloc) {
        expect(bloc.state.picked, ['bag_cafe', 'bag_bakery']);
        expect(bloc.state.needsCleanUrl, isTrue);
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an offered slot picks its window',
      build: build,
      seed: () => loaded(),
      act: (bloc) => bloc.add(
        CheckoutLinkChanged(const ['bag_cafe'], secondWindow.slotParam),
      ),
      expect: () => [loaded(linkSlot: secondWindow.slotParam)],
      verify: (bloc) => expect(bloc.state.needsCleanUrl, isFalse),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a slot that is not offered picks nothing and needs cleaning',
      build: build,
      seed: () => loaded(),
      act: (bloc) => bloc.add(
        const CheckoutLinkChanged(['bag_cafe'], '2026-11-15T03:00Z'),
      ),
      verify: (bloc) {
        expect(bloc.state.window, isNull);
        expect(bloc.state.needsCleanUrl, isTrue);
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'the full ISO form of an offered slot picks it and asks for the compact form',
      build: build,
      seed: () => loaded(),
      act: (bloc) => bloc.add(
        CheckoutLinkChanged(const [
          'bag_cafe',
        ], firstWindow.start.toIso8601String()),
      ),
      verify: (bloc) {
        expect(bloc.state.window, firstWindow);
        expect(bloc.state.needsCleanUrl, isTrue);
      },
    );
  });

  group('card', () {
    blocTest<CheckoutBloc, CheckoutState>(
      'a pick runs, then stores the card from the session',
      setUp: () => when(() => checkout.setPaymentMethod('cs_1', visa.id))
          .thenAnswer((_) async => PaymentMethodSet(openSession(card: visa))),
      build: build,
      seed: () => loaded(linkSlot: firstWindow.slotParam),
      act: (bloc) => bloc.add(CheckoutCardPicked(visa.id)),
      expect: () => [
        loaded(linkSlot: firstWindow.slotParam)
            .copyWith(pendingCardId: () => visa.id),
        ready,
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an unknown card shows the card error and keeps the old card',
      setUp: () =>
          when(() => checkout.setPaymentMethod('cs_1', 'card_forged'))
              .thenAnswer((_) async => const CardNotFound()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutCardPicked('card_forged')),
      expect: () => [
        ready.copyWith(pendingCardId: () => 'card_forged'),
        ready.copyWith(error: () => CheckoutError.cardFailed),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a fault shows the card error',
      setUp: () =>
          when(() => checkout.setPaymentMethod(any(), any()))
              .thenAnswer((_) async => const CheckoutUnavailable()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(CheckoutCardPicked(mastercard.id)),
      verify: (bloc) {
        expect(bloc.state.error, CheckoutError.cardFailed);
        expect(bloc.state.cardId, visa.id);
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an expired session shows expired',
      setUp: () =>
          when(() => checkout.setPaymentMethod(any(), any()))
              .thenAnswer((_) async => const SessionExpired()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(CheckoutCardPicked(mastercard.id)),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.expired),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'an unknown session shows not found',
      setUp: () =>
          when(() => checkout.setPaymentMethod(any(), any()))
              .thenAnswer((_) async => const SessionNotFound()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(CheckoutCardPicked(mastercard.id)),
      verify: (bloc) => expect(bloc.state.status, CheckoutStatus.notFound),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a completed session carries its order id',
      setUp: () =>
          when(() => checkout.setPaymentMethod(any(), any()))
              .thenAnswer((_) async => PaymentMethodSet(completedSession)),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(CheckoutCardPicked(mastercard.id)),
      verify: (bloc) => expect(bloc.state.orderId, 'ord_1'),
    );

    final visaAnswer = Completer<SetPaymentMethodResult>();
    blocTest<CheckoutBloc, CheckoutState>(
      'a second pick restarts the first, so the last card wins',
      setUp: () {
        when(() => checkout.setPaymentMethod('cs_1', visa.id))
            .thenAnswer((_) => visaAnswer.future);
        when(() => checkout.setPaymentMethod('cs_1', mastercard.id)).thenAnswer(
          (_) async => PaymentMethodSet(openSession(card: mastercard)),
        );
      },
      build: build,
      seed: () => loaded(linkSlot: firstWindow.slotParam),
      act: (bloc) async {
        bloc
          ..add(CheckoutCardPicked(visa.id))
          ..add(CheckoutCardPicked(mastercard.id));
        await Future<void>.delayed(Duration.zero);
        visaAnswer.complete(PaymentMethodSet(openSession(card: visa)));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (bloc) {
        expect(bloc.state.cardId, mastercard.id);
        expect(bloc.state.pendingCardId, isNull);
      },
    );
  });

  group('confirm', () {
    void answerConfirm(ConfirmCheckoutResult result) =>
        when(() => checkout.confirm(any(), any(), any()))
            .thenAnswer((_) async => result);

    blocTest<CheckoutBloc, CheckoutState>(
      'a confirm sends the draft and carries the order id',
      setUp: () => answerConfirm(const CheckoutConfirmed('ord_1')),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(
          confirming: true,
          status: CheckoutStatus.completed,
          orderId: 'ord_1',
        ),
      ],
      verify: (_) => verify(
        () => checkout.confirm('cs_1', ['bag_cafe'], firstWindow.start),
      ).called(1),
    );

    for (final (label, seed) in [
      ('no window', loaded(card: visa)),
      ('no card', loaded(linkSlot: firstWindow.slotParam)),
      ('a card request running', ready.copyWith(pendingCardId: () => 'x')),
    ]) {
      blocTest<CheckoutBloc, CheckoutState>(
        'a confirm with $label does nothing',
        build: build,
        seed: () => seed,
        act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
        expect: () => <CheckoutState>[],
        verify: (_) => verifyNever(() => checkout.confirm(any(), any(), any())),
      );
    }

    final pending = Completer<ConfirmCheckoutResult>();
    blocTest<CheckoutBloc, CheckoutState>(
      'a second confirm while one runs is dropped',
      setUp: () =>
          when(() => checkout.confirm(any(), any(), any()))
              .thenAnswer((_) => pending.future),
      build: build,
      seed: () => ready,
      act: (bloc) async {
        bloc
          ..add(const CheckoutConfirmRequested())
          ..add(const CheckoutConfirmRequested());
        await Future<void>.delayed(Duration.zero);
        pending.complete(const CheckoutConfirmed('ord_1'));
      },
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(
          confirming: true,
          status: CheckoutStatus.completed,
          orderId: 'ord_1',
        ),
      ],
      verify: (_) =>
          verify(() => checkout.confirm(any(), any(), any())).called(1),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'session not found shows not found',
      setUp: () => answerConfirm(const SessionNotFound()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(status: CheckoutStatus.notFound),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'session expired shows expired',
      setUp: () => answerConfirm(const SessionExpired()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(status: CheckoutStatus.expired),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'payment method missing clears the card and shows the error',
      setUp: () => answerConfirm(const PaymentMethodMissing()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(
          cardId: () => null,
          error: () => CheckoutError.paymentMissing,
        ),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'invalid bags shows the error',
      setUp: () => answerConfirm(const InvalidBags()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(error: () => CheckoutError.invalidBags),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'a fault shows the error and Confirm works again',
      setUp: () => answerConfirm(const CheckoutUnavailable()),
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      expect: () => [
        ready.copyWith(confirming: true),
        ready.copyWith(error: () => CheckoutError.confirmFailed),
      ],
      verify: (bloc) => expect(bloc.state.canConfirm, isTrue),
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'slot unavailable shows the error, reloads and drops the window',
      setUp: () {
        answerConfirm(const SlotUnavailable());
        answerSession(
          CheckoutSessionLoaded(
            CheckoutSession(
              id: 'cs_1',
              status: CheckoutSessionStatus.open,
              expiresAt: now.toUtc(),
              paymentMethod: visa,
              windows: windows.skip(1).toList(),
            ),
            savedCards,
          ),
        );
      },
      build: build,
      seed: () => ready,
      act: (bloc) => bloc.add(const CheckoutConfirmRequested()),
      skip: 2,
      verify: (bloc) {
        expect(bloc.state.error, CheckoutError.slotUnavailable);
        expect(bloc.state.window, isNull);
        expect(bloc.state.windows, windows.skip(1));
        expect(bloc.state.needsCleanUrl, isTrue);
        verify(() => checkout.session('cs_1')).called(1);
      },
    );
  });

  blocTest<CheckoutBloc, CheckoutState>(
    'dismissing the error clears it',
    build: build,
    seed: () => ready.copyWith(error: () => CheckoutError.cardFailed),
    act: (bloc) => bloc.add(const CheckoutErrorDismissed()),
    expect: () => [ready],
  );

  test('total adds the picked bags', () {
    final state = loaded(linkIds: ['bag_cafe', 'bag_bakery']);
    expect(state.total, const Money(10998));
  });
}
