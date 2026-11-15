import 'package:get_it/get_it.dart';

import 'order/order_bloc.dart';

/// registerOrdersModule registers the order bloc; the app registers the repository first.
void registerOrdersModule(GetIt sl) {
  sl.registerFactory(() => OrderBloc(orderRepository: sl()));
}
