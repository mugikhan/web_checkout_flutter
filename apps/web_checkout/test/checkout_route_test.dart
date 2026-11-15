import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders/orders.dart';
import 'package:ui/ui.dart';

import 'support/pump_app.dart';

void main() {
  setUpAll(() => registerFallbackValue(DateTime(2026)));

  Future<void> tap(WidgetTester tester, Key key) async {
    await tester.ensureVisible(find.byKey(key));
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  testWidgets('a signed-in viewer continues straight to a new session', (
    tester,
  ) async {
    final checkout = mockCheckoutRepository();
    await pumpApp(
      tester,
      location: '/?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
      checkout: checkout,
    );

    await tap(tester, CatalogKeys.continueButton);

    expect(currentLocation(tester), '/checkout/cs_1?bags=bag_cafe');
    expect(find.text('Café bag'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    verify(() => checkout.createSession()).called(1);
  });

  testWidgets('a signed-out user signs in, then lands on checkout', (
    tester,
  ) async {
    await pumpApp(tester, location: '/?bags=bag_cafe');

    await tap(tester, CatalogKeys.continueButton);

    expect(
      Uri.decodeFull(currentLocation(tester)),
      '/sign-in?from=/checkout/new?bags=bag_cafe',
    );

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
    await tap(tester, AuthKeys.signInSubmit);

    expect(currentLocation(tester), '/checkout/cs_1?bags=bag_cafe');
    expect(find.text('Your bags'), findsOneWidget);
  });

  testWidgets('/checkout/new with no bags goes to Bags', (tester) async {
    await pumpApp(
      tester,
      location: '/checkout/new',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(currentLocation(tester), '/');
  });

  testWidgets('a signed-out user on a checkout URL goes to sign-in', (
    tester,
  ) async {
    await pumpApp(tester, location: '/checkout/cs_1?bags=bag_cafe');

    expect(
      Uri.decodeFull(currentLocation(tester)),
      '/sign-in?from=/checkout/cs_1?bags=bag_cafe',
    );
  });

  testWidgets('a window pick puts the slot in the URL', (tester) async {
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
    );

    final chip = find.byType(WindowChip).first;
    final slot = tester.widget<WindowChip>(chip).key! as ValueKey<String>;
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(
      currentLocation(tester),
      '/checkout/cs_1?bags=bag_cafe&slot=${slot.value.replaceFirst('checkout-window-', '')}',
    );
    expect(tester.widget<WindowChip>(chip).selected, isTrue);
  });

  testWidgets('a passed slot leaves the URL and shows the notice', (
    tester,
  ) async {
    final passed = CollectionWindow(
      DateTime.now().subtract(const Duration(days: 1)),
    ).slotParam;
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe&slot=$passed',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(currentLocation(tester), '/checkout/cs_1?bags=bag_cafe');
    expect(
      find.text(
        'That time slot is no longer available, please select another time '
        'slot and confirm your order',
      ),
      findsOneWidget,
    );
  });

  testWidgets('slot unavailable on confirm stays on checkout without a slot', (
    tester,
  ) async {
    final checkout = mockCheckoutRepository(session: openSession(card: visa));
    final slot = CollectionWindow.offered(DateTime.now()).first;
    when(() => checkout.confirm(any(), any(), any()))
        .thenAnswer((_) async => const SlotUnavailable());
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe&slot=${slot.slotParam}',
      repository: mockAuthRepository(viewer: naledi),
      checkout: checkout,
    );
    when(() => checkout.session('cs_1')).thenAnswer(
      (_) async => CheckoutSessionLoaded(
        CheckoutSession(
          id: 'cs_1',
          status: CheckoutSessionStatus.open,
          expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
          paymentMethod: visa,
          windows: CollectionWindow.offered(DateTime.now()).skip(1).toList(),
        ),
        const [visa],
      ),
    );

    await tap(tester, CheckoutKeys.confirm);

    expect(currentLocation(tester), '/checkout/cs_1?bags=bag_cafe');
    expect(find.byKey(CheckoutKeys.errorNotice), findsOneWidget);
  });

  testWidgets('confirm lands on the order page under Bags', (tester) async {
    final checkout = mockCheckoutRepository(session: openSession(card: visa));
    final slot = CollectionWindow.offered(DateTime.now()).first;
    when(() => checkout.confirm('cs_1', ['bag_cafe'], slot.start))
        .thenAnswer((_) async => const CheckoutConfirmed('ord_1'));
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe&slot=${slot.slotParam}',
      repository: mockAuthRepository(viewer: naledi),
      checkout: checkout,
    );

    await tap(tester, CheckoutKeys.confirm);

    expect(currentLocation(tester), '/orders/ord_1');
    expect(find.text('Order placed'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(OrdersKeys.orderId)).data, 'ord_1');
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 0);
  });

  testWidgets('a completed session moves to its order', (tester) async {
    final completed = CheckoutSession(
      id: 'cs_1',
      status: CheckoutSessionStatus.completed,
      expiresAt: DateTime.now().toUtc(),
      orderId: 'ord_1',
    );
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
      checkout: mockCheckoutRepository(session: completed),
    );

    expect(currentLocation(tester), '/orders/ord_1');
    expect(find.text('Order placed'), findsOneWidget);
  });

  testWidgets('an unknown session starts again with the same bags', (
    tester,
  ) async {
    await pumpApp(
      tester,
      location: '/checkout/cs_unknown?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(find.text('Checkout not found'), findsOneWidget);
    await tap(tester, CheckoutKeys.startAgain);

    expect(currentLocation(tester), '/checkout/cs_1?bags=bag_cafe');
  });

  testWidgets('close returns to Bags with the picks', (tester) async {
    await pumpApp(
      tester,
      location: '/checkout/cs_1?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
    );

    await tap(tester, CheckoutKeys.close);

    expect(currentLocation(tester), '/?bags=bag_cafe');
    expect(
      tester.widget<BagTile>(find.byKey(CatalogKeys.bag('bag_cafe'))).selected,
      isTrue,
    );
  });
}
