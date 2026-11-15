import 'package:api/domain/domain.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders/orders.dart';
import 'package:ui/ui.dart';

import 'support/pump_app.dart';

void main() {
  Future<void> tapBack(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(OrdersKeys.backToBags));
    await tester.tap(find.byKey(OrdersKeys.backToBags));
    await tester.pumpAndSettle();
  }

  testWidgets('/orders/:id sends a signed-out user to sign-in', (tester) async {
    await pumpApp(tester, location: '/orders/ord_1');

    expect(
      Uri.decodeFull(currentLocation(tester)),
      '/sign-in?from=/orders/ord_1',
    );
  });

  testWidgets('/orders/:id shows the order under Bags, also after a refresh', (
    tester,
  ) async {
    await pumpApp(
      tester,
      location: '/orders/ord_1',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(currentLocation(tester), '/orders/ord_1');
    expect(find.text('Order placed'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(OrdersKeys.orderId)).data, 'ord_1');
    expect(find.text('Corner Pantry'), findsOneWidget);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 0);
  });

  testWidgets('Back to bags opens Bags with no bags picked', (tester) async {
    await pumpApp(
      tester,
      location: '/orders/ord_1',
      repository: mockAuthRepository(viewer: naledi),
    );

    await tapBack(tester);

    expect(currentLocation(tester), '/');
    expect(
      tester.widget<BagTile>(find.byKey(CatalogKeys.bag('bag_cafe'))).selected,
      isFalse,
    );
  });

  testWidgets('an unknown order id shows Order not found', (tester) async {
    await pumpApp(
      tester,
      location: '/orders/ord_missing',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(find.text('Order not found'), findsOneWidget);
    expect(find.text('Order placed'), findsNothing);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 0);

    await tapBack(tester);
    expect(currentLocation(tester), '/');
  });

  testWidgets('a pending order follows its status to Confirmed', (
    tester,
  ) async {
    final orders = mockOrderRepository(order: settledOrderPending());
    final updates = Stream<OrderResult>.value(OrderLoaded(settledOrder));
    when(() => orders.watchStatus('ord_1')).thenAnswer((_) => updates);

    await pumpApp(
      tester,
      location: '/orders/ord_1',
      repository: mockAuthRepository(viewer: naledi),
      orders: orders,
    );

    expect(find.byKey(OrdersKeys.backToBags), findsOneWidget);
  });

  testWidgets('Back to bags leaves no order page on screen after one frame', (
    tester,
  ) async {
    await pumpApp(
      tester,
      location: '/orders/ord_1',
      repository: mockAuthRepository(viewer: naledi),
    );

    await tester.ensureVisible(find.byKey(OrdersKeys.backToBags));
    await tester.tap(find.byKey(OrdersKeys.backToBags));
    await tester.pump();

    expect(find.byType(OrderPage), findsNothing);
    expect(find.byType(CatalogPage), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(OrderPage), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets(
    'Back to bags leaves no order page on screen after one frame, on Android',
    (tester) async {
      await pumpApp(
        tester,
        location: '/orders/ord_1',
        repository: mockAuthRepository(viewer: naledi),
      );

      await tester.ensureVisible(find.byKey(OrdersKeys.backToBags));
      await tester.tap(find.byKey(OrdersKeys.backToBags));
      await tester.pump();

      expect(find.byType(OrderPage), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets(
    'prices stay as confirmed: the order page shows the stored prices',
    (tester) async {
      final stored = Order(
        id: 'ord_1',
        status: OrderStatus.confirmed,
        store: 'Corner Pantry',
        bags: const [
          OrderBag(id: 'bag_cafe', name: 'Café bag', price: Money(4500)),
          OrderBag(id: 'bag_bakery', name: 'Bakery bag', price: Money(3000)),
        ],
        total: const Money(7500),
        window: settledOrder.window,
        card: settledOrder.card,
        createdAt: settledOrder.createdAt,
        holdConfirmsAt: settledOrder.holdConfirmsAt,
      );
      await pumpApp(
        tester,
        location: '/orders/ord_1',
        repository: mockAuthRepository(viewer: naledi),
        orders: mockOrderRepository(order: stored),
      );

      expect(find.text('R45,00'), findsOneWidget);
      expect(find.text('R30,00'), findsOneWidget);
      expect(find.text('R75,00'), findsOneWidget);
      expect(find.text('R59,99'), findsNothing);
      expect(find.text('R49,99'), findsNothing);
    },
  );
}
