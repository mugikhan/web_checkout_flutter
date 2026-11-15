import '../graphql/orders.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../link/request_context.dart';
import 'auth_resolvers.dart';
import 'checkout_store.dart';
import 'session_store.dart';

/// OrderResolvers answers the order query and the status subscription.
class OrderResolvers {
  OrderResolvers({
    required this._viewers,
    required this._store,
    required this._clock,
    required this._delay,
  });

  final SessionStore _viewers;
  final CheckoutStore _store;
  final DateTime Function() _clock;
  final Future<void> Function(Duration) _delay;

  Future<Query$Order> order(
    Variables$Query$Order variables,
    RequestContext context,
  ) async {
    final stored = await _owned(variables.id, context);
    return Query$Order(
      order: Query$Order$order.fromJson(
        _result(variables.id, stored, _clock().toUtc()),
      ),
    );
  }

  /// orderStatusChanged emits the order, then the settled order when a hold ends.
  Stream<Subscription$OrderStatusChanged> orderStatusChanged(
    Variables$Subscription$OrderStatusChanged variables,
    RequestContext context,
  ) async* {
    final id = variables.orderId;
    final stored = await _owned(id, context);
    Subscription$OrderStatusChanged event(DateTime now) =>
        Subscription$OrderStatusChanged(
          orderStatusChanged:
              Subscription$OrderStatusChanged$orderStatusChanged.fromJson(
                _result(id, stored, now),
              ),
        );

    final now = _clock().toUtc();
    yield event(now);
    if (stored == null) return;

    final settleAt = DateTime.parse(stored['holdConfirmsAt'] as String);
    if (!now.isBefore(settleAt)) return;
    await _delay(settleAt.difference(now));
    // A timer can fire a little early, so read the order at the hold time itself.
    yield event(settleAt);
  }

  Future<Map<String, dynamic>?> _owned(
    String id,
    RequestContext context,
  ) async {
    final token = context.token;
    final name = token == null ? null : await _viewers.nameFor(token);
    if (name == null) return null;
    final stored = await _store.order(id);
    return stored?['ownerId'] == AuthResolvers.viewerId(name) ? stored : null;
  }

  static Map<String, dynamic> _result(
    String id,
    Map<String, dynamic>? stored,
    DateTime now,
  ) {
    if (stored == null) {
      return Query$Order$order$$OrderNotFound(orderId: id).toJson();
    }
    return _fields(stored, now).toJson();
  }

  static Fragment$OrderFields _fields(
    Map<String, dynamic> order,
    DateTime now,
  ) {
    final window = order['window'] as Map<String, dynamic>;
    final card = order['paymentMethod'] as Map<String, dynamic>;
    return Fragment$OrderFields(
      id: order['id'] as String,
      status: _status(order, now),
      store: order['store'] as String,
      bags: [
        for (final bag in order['bags'] as List<dynamic>)
          Fragment$OrderFields$bags(
            id: (bag as Map<String, dynamic>)['id'] as String,
            name: bag['name'] as String,
            priceCents: bag['priceCents'] as int,
          ),
      ],
      totalCents: order['totalCents'] as int,
      window: Fragment$OrderFields$window(
        startsAt: window['startsAt'] as String,
        endsAt: window['endsAt'] as String,
      ),
      card: Fragment$OrderFields$card(
        brand: card['brand'] as String,
        last4: card['last4'] as String,
      ),
      createdAt: order['createdAt'] as String,
      holdConfirmsAt: order['holdConfirmsAt'] as String,
    );
  }

  static Enum$OrderStatus _status(Map<String, dynamic> order, DateTime now) {
    final settleAt = DateTime.parse(order['holdConfirmsAt'] as String);
    if (now.isBefore(settleAt)) return Enum$OrderStatus.PENDING;
    return order['declines'] as bool
        ? Enum$OrderStatus.FAILED
        : Enum$OrderStatus.CONFIRMED;
  }
}
