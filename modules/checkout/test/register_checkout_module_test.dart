import 'package:api/domain/domain.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'support/mocks.dart';

void main() {
  test('registers both blocs as factories', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton<CheckoutRepository>(MockCheckoutRepository())
      ..registerSingleton<CatalogRepository>(MockCatalogRepository());

    registerCheckoutModule(sl);

    expect(sl<CheckoutStartBloc>(), isNot(same(sl<CheckoutStartBloc>())));
    expect(sl<CheckoutBloc>(), isNot(same(sl<CheckoutBloc>())));
  });
}
