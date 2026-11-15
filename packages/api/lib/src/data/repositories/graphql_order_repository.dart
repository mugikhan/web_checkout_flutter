import 'package:graphql/client.dart'
    show FetchPolicy, GraphQLClient, QueryResult;

import '../../domain/catalog/money.dart';
import '../../domain/checkout/collection_window.dart';
import '../../domain/orders/order.dart';
import '../../domain/orders/order_repository.dart';
import '../../domain/orders/order_result.dart';
import '../graphql/orders.graphql.dart';
import '../graphql/schema.graphql.dart';

/// GraphqlOrderRepository implements [OrderRepository] over the GraphQL client.
class GraphqlOrderRepository implements OrderRepository {
  GraphqlOrderRepository({required this._client});

  final GraphQLClient _client;

  @override
  Future<OrderResult> order(String id) async {
    final result = await _client.query$Order(
      Options$Query$Order(
        fetchPolicy: FetchPolicy.noCache,
        variables: Variables$Query$Order(id: id),
      ),
    );
    final data = result.parsedData;
    if (result.hasException || data == null) return const OrderUnavailable();
    return _toResult(data.order);
  }

  @override
  Stream<OrderResult> watchStatus(String id) async* {
    final updates = _client.subscribe$OrderStatusChanged(
      Options$Subscription$OrderStatusChanged(
        fetchPolicy: FetchPolicy.noCache,
        variables: Variables$Subscription$OrderStatusChanged(orderId: id),
      ),
    );
    await for (final QueryResult<Subscription$OrderStatusChanged> result
        in updates) {
      final data = result.parsedData;
      yield result.hasException || data == null
          ? const OrderUnavailable()
          : _toResult(data.orderStatusChanged);
    }
  }

  static OrderResult _toResult(Object? union) => switch (union) {
    final Fragment$OrderFields fields => _toOrder(fields),
    Query$Order$order$$OrderNotFound() ||
    Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound() =>
      const OrderNotFound(),
    _ => const OrderUnavailable(),
  };

  static OrderResult _toOrder(Fragment$OrderFields fields) {
    final status = switch (fields.status) {
      Enum$OrderStatus.CREATED => OrderStatus.created,
      Enum$OrderStatus.PENDING => OrderStatus.pending,
      Enum$OrderStatus.CONFIRMED => OrderStatus.confirmed,
      Enum$OrderStatus.FAILED => OrderStatus.failed,
      Enum$OrderStatus.$unknown => null,
    };
    if (status == null) return const OrderUnavailable();
    return OrderLoaded(
      Order(
        id: fields.id,
        status: status,
        store: fields.store,
        bags: [
          for (final bag in fields.bags)
            OrderBag(id: bag.id, name: bag.name, price: Money(bag.priceCents)),
        ],
        total: Money(fields.totalCents),
        window: CollectionWindow(DateTime.parse(fields.window.startsAt)),
        card: OrderCard(brand: fields.card.brand, last4: fields.card.last4),
        createdAt: DateTime.parse(fields.createdAt),
        holdConfirmsAt: DateTime.parse(fields.holdConfirmsAt),
      ),
    );
  }
}
