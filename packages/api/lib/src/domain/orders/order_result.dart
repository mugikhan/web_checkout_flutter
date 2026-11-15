import 'order.dart';

/// OrderResult is the outcome of reading an order or one status update.
sealed class OrderResult {
  const OrderResult();
}

final class OrderLoaded extends OrderResult {
  const OrderLoaded(this.order);

  final Order order;

  @override
  bool operator ==(Object other) =>
      other is OrderLoaded && other.order == order;

  @override
  int get hashCode => order.hashCode;
}

/// OrderNotFound means the order does not exist or another viewer owns it.
final class OrderNotFound extends OrderResult {
  const OrderNotFound();

  @override
  bool operator ==(Object other) => other is OrderNotFound;

  @override
  int get hashCode => (OrderNotFound).hashCode;
}

/// OrderUnavailable means the request failed for an unexpected reason.
final class OrderUnavailable extends OrderResult {
  const OrderUnavailable();

  @override
  bool operator ==(Object other) => other is OrderUnavailable;

  @override
  int get hashCode => (OrderUnavailable).hashCode;
}
