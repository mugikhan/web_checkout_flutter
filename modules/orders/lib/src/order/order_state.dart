import 'package:api/domain/domain.dart';

enum OrderLoadStatus { loading, loaded, notFound, failed }

/// OrderState holds the order the page shows and how its load went.
class OrderState {
  const OrderState({
    this.status = OrderLoadStatus.loading,
    this.orderId = '',
    this.order,
  });

  final OrderLoadStatus status;
  final String orderId;

  /// order is set once [status] is loaded.
  final Order? order;

  @override
  bool operator ==(Object other) =>
      other is OrderState &&
      other.status == status &&
      other.orderId == orderId &&
      other.order == order;

  @override
  int get hashCode => Object.hash(status, orderId, order);

  @override
  String toString() => 'OrderState(${status.name}, $orderId, $order)';
}
