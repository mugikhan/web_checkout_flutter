sealed class OrderEvent {
  const OrderEvent();
}

/// OrderLoadRequested loads the order, then follows it while it is Pending.
final class OrderLoadRequested extends OrderEvent {
  const OrderLoadRequested(this.orderId);

  final String orderId;
}
