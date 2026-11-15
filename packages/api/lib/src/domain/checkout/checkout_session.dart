import 'package:flutter/foundation.dart';

import 'collection_window.dart';
import 'saved_card.dart';

enum CheckoutSessionStatus { open, completed, expired }

/// CheckoutSession is the "server" record whose id is the idempotency key.
final class CheckoutSession {
  const CheckoutSession({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.orderId,
    this.paymentMethod,
    this.windows = const [],
  });

  final String id;
  final CheckoutSessionStatus status;
  final DateTime expiresAt;

  /// orderId is set once the session is completed.
  final String? orderId;
  final SavedCard? paymentMethod;

  /// windows holds the offered collection windows while the session is open.
  final List<CollectionWindow> windows;

  @override
  bool operator ==(Object other) =>
      other is CheckoutSession &&
      other.id == id &&
      other.status == status &&
      other.expiresAt == expiresAt &&
      other.orderId == orderId &&
      other.paymentMethod == paymentMethod &&
      listEquals(other.windows, windows);

  @override
  int get hashCode => Object.hash(
    id,
    status,
    expiresAt,
    orderId,
    paymentMethod,
    Object.hashAll(windows),
  );

  @override
  String toString() => 'CheckoutSession($id, ${status.name})';
}
