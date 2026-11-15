import 'package:api/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orders/orders.dart';
import 'package:ui/ui.dart';

/// pumpOrder pumps the order page for `ord_1`; pass `settle: false` while it loads.
Future<List<String>> pumpOrder(
  WidgetTester tester, {
  required OrderRepository repository,
  Size size = const Size(400, 1600),
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final backs = <String>[];
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(textTheme: ThemeData().textTheme),
      home: Scaffold(
        body: BlocProvider(
          create: (_) =>
              OrderBloc(orderRepository: repository)
                ..add(const OrderLoadRequested('ord_1')),
          child: OrderPage(onBackToBags: () => backs.add('back')),
        ),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return backs;
}
