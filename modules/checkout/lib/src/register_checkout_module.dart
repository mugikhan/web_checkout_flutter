import 'package:get_it/get_it.dart';

import 'checkout/checkout_bloc.dart';
import 'start/checkout_start_bloc.dart';

/// registerCheckoutModule registers the checkout blocs; the app registers the repositories first.
void registerCheckoutModule(GetIt sl) {
  sl
    ..registerFactory(() => CheckoutStartBloc(checkoutRepository: sl()))
    ..registerFactory(
      () => CheckoutBloc(checkoutRepository: sl(), catalogRepository: sl()),
    );
}
