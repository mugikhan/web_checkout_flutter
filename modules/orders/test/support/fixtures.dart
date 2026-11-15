import 'package:api/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

/// createdAt is 10:30 local time, so the hold settles at 10:30:03.
final createdAt = DateTime(2026, 11, 15, 10, 30);

Order orderWith(
  OrderStatus status, {
  String id = 'ord_1',
  OrderCard card = const OrderCard(brand: 'Visa', last4: '4242'),
}) => Order(
  id: id,
  status: status,
  store: 'Corner Pantry',
  bags: const [
    OrderBag(id: 'bag_cafe', name: 'Café bag', price: Money(5999)),
    OrderBag(id: 'bag_bakery', name: 'Bakery bag', price: Money(4999)),
  ],
  total: const Money(10998),
  window: CollectionWindow(DateTime(2026, 11, 15, 13)),
  card: card,
  createdAt: createdAt,
  holdConfirmsAt: createdAt.add(const Duration(seconds: 3)),
);

final pending = orderWith(OrderStatus.pending);
final confirmed = orderWith(OrderStatus.confirmed);
final failed = orderWith(
  OrderStatus.failed,
  card: const OrderCard(brand: 'Mastercard', last4: '0002'),
);
