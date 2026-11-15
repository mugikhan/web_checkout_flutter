import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui/ui.dart';

import 'support/mocks.dart';
import 'support/pump_checkout.dart';

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

  void answerSession(CheckoutSessionResult result) =>
      when(() => checkout.session('cs_1')).thenAnswer((_) async => result);

  Future<CheckoutCalls> pump(
    WidgetTester tester, {
    List<String> bagIds = const ['bag_cafe'],
    String? slot,
    Size size = const Size(400, 1600),
  }) => pumpCheckout(
    tester,
    checkout: checkout,
    catalog: catalog,
    bagIds: bagIds,
    slot: slot,
    size: size,
  );

  AppButton confirm(WidgetTester tester) =>
      tester.widget<AppButton>(find.byKey(CheckoutKeys.confirm));

  Future<void> tap(WidgetTester tester, Key key) async {
    await tester.ensureVisible(find.byKey(key));
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a loading view while the session loads', (tester) async {
    final pending = Completer<CheckoutSessionResult>();
    when(() => checkout.session('cs_1')).thenAnswer((_) => pending.future);

    await pumpCheckout(
      tester,
      checkout: checkout,
      catalog: catalog,
      settle: false,
    );
    await tester.pump();

    expect(find.text('Loading checkout'), findsOneWidget);
    pending.complete(const SessionNotFound());
    await tester.pumpAndSettle();
  });

  testWidgets('a load failure shows the error view and retries', (
    tester,
  ) async {
    answerSession(const CheckoutUnavailable());
    await pump(tester);

    expect(find.text('Checkout could not load'), findsOneWidget);

    answerSession(CheckoutSessionLoaded(openSession(), savedCards));
    await tap(tester, CheckoutKeys.retry);

    expect(find.text('Your bags'), findsOneWidget);
  });

  testWidgets('an unknown session shows not found with Start again', (
    tester,
  ) async {
    answerSession(const SessionNotFound());
    final calls = await pump(tester, bagIds: ['bag_cafe'], slot: 'x');

    expect(find.text('Checkout not found'), findsOneWidget);
    await tap(tester, CheckoutKeys.startAgain);

    expect(calls.startAgains, ['bag_cafe|x']);
  });

  testWidgets('an expired session shows expired with Start again', (
    tester,
  ) async {
    answerSession(CheckoutSessionLoaded(expiredSession, savedCards));
    final calls = await pump(tester, bagIds: ['bag_cafe', 'bag_bakery']);

    expect(find.text('This checkout expired'), findsOneWidget);
    await tap(tester, CheckoutKeys.startAgain);

    expect(calls.startAgains, ['bag_cafe,bag_bakery|null']);
  });

  testWidgets('a completed session asks for its order', (tester) async {
    answerSession(CheckoutSessionLoaded(completedSession, savedCards));
    final calls = await pumpCheckout(
      tester,
      checkout: checkout,
      catalog: catalog,
      settle: false,
    );
    await tester.pump();
    await tester.pump();

    expect(calls.completed, ['ord_1']);
  });

  testWidgets('no valid bags shows the empty view with Go to Bags', (
    tester,
  ) async {
    answerSession(CheckoutSessionLoaded(openSession(), savedCards));
    final calls = await pump(tester, bagIds: ['bag_unknown']);

    expect(find.text('No bags to check out'), findsOneWidget);
    await tap(tester, CheckoutKeys.goToBags);

    expect(calls.closes, ['']);
  });

  testWidgets('bad bags and a passed slot are cleaned in the URL', (
    tester,
  ) async {
    answerSession(CheckoutSessionLoaded(openSession(), savedCards));
    final calls = await pump(
      tester,
      bagIds: ['bag_cafe', 'bag_cafe', 'bag_bakery', 'bag_grocery'],
      slot: '2026-11-15T03:00Z',
    );

    expect(calls.drafts, ['bag_cafe,bag_bakery|null']);
    expect(find.text('Café bag'), findsOneWidget);
    expect(find.text('Bakery bag'), findsOneWidget);
    expect(find.text('Grocery bag'), findsNothing);
  });

  group('ready', () {
    setUp(
      () => answerSession(CheckoutSessionLoaded(openSession(), savedCards)),
    );

    testWidgets('lists bags, windows by day and cards, with nothing picked', (
      tester,
    ) async {
      await pump(tester, bagIds: ['bag_cafe', 'bag_bakery']);

      expect(find.text('Café bag'), findsOneWidget);
      expect(find.text('R109,98'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Tomorrow'), findsOneWidget);
      expect(find.byType(WindowChip), findsNWidgets(windows.length));
      expect(find.text('13:00–14:00'), findsNWidgets(2));
      expect(find.text('Visa •••• 4242'), findsOneWidget);
      expect(find.text('Mastercard •••• 0002'), findsOneWidget);
      expect(
        tester
            .widgetList<WindowChip>(find.byType(WindowChip))
            .any((c) => c.selected),
        isFalse,
      );
      expect(
        tester
            .widgetList<SavedCardTile>(find.byType(SavedCardTile))
            .any((c) => c.selected),
        isFalse,
      );
      expect(confirm(tester).onPressed, isNull);
      expect(
        find.text('Pick a collection window and a card to confirm.'),
        findsOneWidget,
      );
    });

    testWidgets('a window pick asks for the slot in the URL', (tester) async {
      final calls = await pump(tester);

      await tap(tester, CheckoutKeys.window(firstWindow.slotParam));

      expect(calls.drafts, ['bag_cafe|${firstWindow.slotParam}']);
      expect(
        tester
            .widget<WindowChip>(
              find.byKey(CheckoutKeys.window(firstWindow.slotParam)),
            )
            .selected,
        isTrue,
      );
      expect(confirm(tester).onPressed, isNull);
      expect(find.text('Pick a card to confirm.'), findsOneWidget);
    });

    testWidgets('a card and a window enable Confirm, which completes', (
      tester,
    ) async {
      when(() => checkout.setPaymentMethod('cs_1', visa.id))
          .thenAnswer((_) async => PaymentMethodSet(openSession(card: visa)));
      when(() => checkout.confirm('cs_1', ['bag_cafe'], firstWindow.start))
          .thenAnswer((_) async => const CheckoutConfirmed('ord_1'));
      final calls = await pump(tester, slot: firstWindow.slotParam);

      await tap(tester, CheckoutKeys.card(visa.id));

      expect(
        tester
            .widget<SavedCardTile>(find.byKey(CheckoutKeys.card(visa.id)))
            .selected,
        isTrue,
      );
      expect(confirm(tester).onPressed, isNotNull);

      await tester.tap(find.byKey(CheckoutKeys.confirm));
      await tester.pump();
      await tester.pump();

      expect(calls.completed, ['ord_1']);
    });

    testWidgets('a running card request shows busy and disables Confirm', (
      tester,
    ) async {
      final pending = Completer<SetPaymentMethodResult>();
      when(() => checkout.setPaymentMethod('cs_1', visa.id))
          .thenAnswer((_) => pending.future);
      await pump(tester, slot: firstWindow.slotParam);

      await tester.ensureVisible(find.byKey(CheckoutKeys.card(visa.id)));
      await tester.tap(find.byKey(CheckoutKeys.card(visa.id)));
      await tester.pump();

      expect(
        tester
            .widget<SavedCardTile>(find.byKey(CheckoutKeys.card(visa.id)))
            .busy,
        isTrue,
      );
      expect(confirm(tester).onPressed, isNull);
      pending.complete(PaymentMethodSet(openSession(card: visa)));
      await tester.pumpAndSettle();
    });

    testWidgets('a card failure shows the notice, which dismisses', (
      tester,
    ) async {
      when(() => checkout.setPaymentMethod(any(), any()))
          .thenAnswer((_) async => const CardNotFound());
      await pump(tester);

      await tap(tester, CheckoutKeys.card(visa.id));

      expect(
        find.text('That card could not be used. Pick another.'),
        findsOneWidget,
      );
      await tap(tester, CheckoutKeys.errorDismiss);
      expect(find.byKey(CheckoutKeys.errorNotice), findsNothing);
    });

    testWidgets('close hands back the clean bags', (tester) async {
      final calls = await pump(tester, bagIds: ['bag_cafe', 'bag_cafe']);

      await tap(tester, CheckoutKeys.close);

      expect(calls.closes, ['bag_cafe']);
    });

    testWidgets('compact windows show one column and a confirm bar', (
      tester,
    ) async {
      await pump(tester, size: const Size(700, 1600));

      expect(find.text('Order summary'), findsNothing);
      expect(find.byKey(CheckoutKeys.summaryTotal), findsOneWidget);
      expect(find.byKey(CheckoutKeys.confirm), findsOneWidget);
    });

    testWidgets('expanded windows show the summary column', (tester) async {
      await pump(tester, size: const Size(1200, 1600));

      expect(find.text('Order summary'), findsOneWidget);
      final summary = tester.getTopLeft(find.text('Order summary'));
      final bags = tester.getTopLeft(find.text('Your bags'));
      expect(summary.dx, greaterThan(bags.dx));
      expect(find.byKey(CheckoutKeys.confirm), findsOneWidget);
    });

    testWidgets('windows and cards carry screen reader labels', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, slot: firstWindow.slotParam);

      expect(
        tester.getSemantics(
          find.byKey(CheckoutKeys.window(firstWindow.slotParam)),
        ),
        isSemantics(
          label: 'Today, 13:00 to 14:00',
          isSelected: true,
          hasSelectedState: true,
          isButton: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byKey(CheckoutKeys.card(visa.id))),
        isSemantics(
          label: 'Visa ending in 4242',
          hasSelectedState: true,
          isButton: true,
          hasTapAction: true,
        ),
      );
      expect(find.byTooltip('Close checkout'), findsOneWidget);
      semantics.dispose();
    });
  });
}
