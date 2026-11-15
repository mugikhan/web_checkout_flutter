import 'package:flutter/foundation.dart';

import '../catalog/money.dart';
import '../checkout/collection_window.dart';

enum OrderStatus { created, pending, confirmed, failed }

/// OrderBag is a bag as the order confirmed it, with its price at that time.
final class OrderBag {
  const OrderBag({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final Money price;

  @override
  bool operator ==(Object other) =>
      other is OrderBag &&
      other.id == id &&
      other.name == name &&
      other.price == price;

  @override
  int get hashCode => Object.hash(id, name, price);
}

/// OrderCard is the masked card an order was paid with.
final class OrderCard {
  const OrderCard({required this.brand, required this.last4});

  final String brand;
  final String last4;

  @override
  bool operator ==(Object other) =>
      other is OrderCard && other.brand == brand && other.last4 == last4;

  @override
  int get hashCode => Object.hash(brand, last4);
}

/// Order is a placed order with the status the "server" derives at read time.
final class Order {
  const Order({
    required this.id,
    required this.status,
    required this.store,
    required this.bags,
    required this.total,
    required this.window,
    required this.card,
    required this.createdAt,
    required this.holdConfirmsAt,
  });

  final String id;
  final OrderStatus status;
  final String store;
  final List<OrderBag> bags;
  final Money total;
  final CollectionWindow window;
  final OrderCard card;
  final DateTime createdAt;

  /// holdConfirmsAt is when the payment hold settles to Confirmed or Failed.
  final DateTime holdConfirmsAt;

  bool get isSettled =>
      status == OrderStatus.confirmed || status == OrderStatus.failed;

  @override
  bool operator ==(Object other) =>
      other is Order &&
      other.id == id &&
      other.status == status &&
      other.store == store &&
      listEquals(other.bags, bags) &&
      other.total == total &&
      other.window.start == window.start &&
      other.card == card &&
      other.createdAt == createdAt &&
      other.holdConfirmsAt == holdConfirmsAt;

  @override
  int get hashCode => Object.hash(
    id,
    status,
    store,
    Object.hashAll(bags),
    total,
    window.start,
    card,
    createdAt,
    holdConfirmsAt,
  );

  @override
  String toString() => 'Order($id, ${status.name})';
}
