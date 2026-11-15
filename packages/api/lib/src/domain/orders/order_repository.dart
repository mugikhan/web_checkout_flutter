import 'order_result.dart';

/// OrderRepository reads an order and follows its status on the "server".
abstract interface class OrderRepository {
  Future<OrderResult> order(String id);

  /// watchStatus emits the order now, then once more when a pending hold settles.
  Stream<OrderResult> watchStatus(String id);
}
