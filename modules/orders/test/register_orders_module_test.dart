import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:orders/orders.dart';

import 'support/fixtures.dart';

void main() {
  test('registers the order bloc as a factory', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton<OrderRepository>(MockOrderRepository());

    registerOrdersModule(sl);

    expect(sl<OrderBloc>(), isNot(same(sl<OrderBloc>())));
  });
}
