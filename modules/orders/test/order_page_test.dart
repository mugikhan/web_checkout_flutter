import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders/orders.dart';
import 'package:ui/ui.dart';

import 'support/fixtures.dart';
import 'support/pump_order.dart';

void main() {
  late MockOrderRepository repository;
  late StreamController<OrderResult> updates;

  setUp(() {
    repository = MockOrderRepository();
    updates = StreamController<OrderResult>();
    when(() => repository.watchStatus(any())).thenAnswer((_) => updates.stream);
  });

  // close() waits for a listener, so do not await it.
  tearDown(() => unawaited(updates.close()));

  void answer(OrderResult result) =>
      when(() => repository.order('ord_1')).thenAnswer((_) async => result);

  Color? marker(WidgetTester tester, int index) =>
      tester.widget<Icon>(find.byKey(StatusTimeline.markerKey(index))).color;

  testWidgets('shows the order details for a settled Visa order', (
    tester,
  ) async {
    answer(OrderLoaded(confirmed));
    await pumpOrder(tester, repository: repository);

    expect(find.text('Order placed'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(OrdersKeys.orderId)).data, 'ord_1');
    expect(
      tester.widget<Text>(find.byKey(OrdersKeys.store)).data,
      'Corner Pantry',
    );
    expect(find.text('Café bag'), findsOneWidget);
    expect(find.text('R59,99'), findsOneWidget);
    expect(find.text('Bakery bag'), findsOneWidget);
    expect(find.text('R49,99'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(OrdersKeys.total)).data, 'R109,98');
    expect(
      tester.widget<Text>(find.byKey(OrdersKeys.window)).data,
      '15/11, 13:00–14:00',
    );
    expect(
      tester.widget<Text>(find.byKey(OrdersKeys.card)).data,
      'Visa •••• 4242',
    );
  });

  testWidgets('a Pending order shows a half-reached timeline and no action', (
    tester,
  ) async {
    answer(OrderLoaded(pending));
    await pumpOrder(tester, repository: repository);

    expect(marker(tester, 0), AppColors.light.primary);
    expect(marker(tester, 1), AppColors.light.primary);
    expect(marker(tester, 2), AppColors.light.onSurfaceVariant);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('10:30'), findsNWidgets(2));
    expect(find.byKey(OrdersKeys.backToBags), findsNothing);
    expect(find.byKey(OrdersKeys.declineNotice), findsNothing);
  });

  testWidgets('Pending turns Confirmed on screen, with Back to bags', (
    tester,
  ) async {
    answer(OrderLoaded(pending));
    final backs = await pumpOrder(tester, repository: repository);

    updates.add(OrderLoaded(confirmed));
    await tester.pumpAndSettle();

    expect(marker(tester, 2), AppColors.light.primary);
    expect(find.text('10:30'), findsNWidgets(3));
    expect(find.byKey(OrdersKeys.declineNotice), findsNothing);
    await tester.tap(find.byKey(OrdersKeys.backToBags));
    expect(backs, ['back']);
  });

  testWidgets('Pending turns Failed with the reason in the error tone', (
    tester,
  ) async {
    answer(OrderLoaded(orderWith(OrderStatus.pending)));
    final backs = await pumpOrder(tester, repository: repository);

    updates.add(OrderLoaded(failed));
    await tester.pumpAndSettle();

    expect(find.text('Failed'), findsOneWidget);
    expect(marker(tester, 2), AppColors.light.error);
    final notice = tester.widget<InlineNotice>(
      find.byKey(OrdersKeys.declineNotice),
    );
    expect(notice.tone, InlineNoticeTone.error);
    expect(
      notice.message,
      'The payment was declined and you were not charged. '
      'Try placing the order again',
    );
    expect(find.text('Try again'), findsNothing);
    await tester.tap(find.byKey(OrdersKeys.backToBags));
    expect(backs, ['back']);
  });

  testWidgets('the decline reason can be dismissed', (tester) async {
    answer(OrderLoaded(failed));
    await pumpOrder(tester, repository: repository);

    await tester.tap(find.byKey(OrdersKeys.declineDismiss));
    await tester.pump();

    expect(find.byKey(OrdersKeys.declineNotice), findsNothing);
    expect(find.byKey(OrdersKeys.backToBags), findsOneWidget);
  });

  testWidgets('an unknown order shows Order not found and Back to bags', (
    tester,
  ) async {
    answer(const OrderNotFound());
    final backs = await pumpOrder(tester, repository: repository);

    expect(find.text('Order not found'), findsOneWidget);
    expect(find.text('Order placed'), findsNothing);
    await tester.tap(find.byKey(OrdersKeys.backToBags));
    expect(backs, ['back']);
  });

  testWidgets('shows a loading state while the order loads', (tester) async {
    final load = Completer<OrderResult>();
    when(() => repository.order('ord_1')).thenAnswer((_) => load.future);
    await pumpOrder(tester, repository: repository, settle: false);

    expect(find.text('Loading order'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    load.complete(OrderLoaded(confirmed));
    await tester.pumpAndSettle();
    expect(find.text('Order placed'), findsOneWidget);
  });

  testWidgets('an unavailable order shows an error with a retry', (
    tester,
  ) async {
    var calls = 0;
    when(() => repository.order('ord_1')).thenAnswer(
      (_) async =>
          ++calls == 1 ? const OrderUnavailable() : OrderLoaded(confirmed),
    );
    await pumpOrder(tester, repository: repository);

    expect(find.text('Order could not load'), findsOneWidget);
    await tester.tap(find.byKey(OrdersKeys.retry));
    await tester.pumpAndSettle();

    expect(find.text('Order placed'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('announces the timeline steps and the back action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    answer(OrderLoaded(confirmed));
    await pumpOrder(tester, repository: repository);

    expect(find.bySemanticsLabel('Created, 10:30'), findsOneWidget);
    expect(find.bySemanticsLabel('Confirmed, 10:30'), findsOneWidget);
    expect(find.bySemanticsLabel('Back to bags'), findsOneWidget);
    semantics.dispose();
  });
}
