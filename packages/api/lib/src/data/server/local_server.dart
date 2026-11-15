import 'dart:math';

import 'package:storage/storage.dart';

import '../graphql/auth.graphql.dart';
import '../graphql/checkout.graphql.dart';
import '../graphql/orders.graphql.dart';
import '../link/local_link.dart';
import 'auth_resolvers.dart';
import 'catalog_resolvers.dart';
import 'checkout_resolvers.dart';
import 'checkout_store.dart';
import 'order_resolvers.dart';
import 'session_store.dart';

/// LocalServer is the in-app "server": one resolver per GraphQL operation.
class LocalServer {
  factory LocalServer(
    KeyValueStore store, {
    Random? random,
    DateTime Function()? clock,
    Future<void> Function(Duration)? delay,
  }) {
    final rng = random ?? Random.secure();
    final viewers = SessionStore(store, random: rng);
    final orders = CheckoutStore(store);
    final now = clock ?? DateTime.now;
    return LocalServer._(
      AuthResolvers(viewers),
      CheckoutResolvers(
        viewers: viewers,
        store: orders,
        random: rng,
        clock: now,
      ),
      OrderResolvers(
        viewers: viewers,
        store: orders,
        clock: now,
        delay: delay ?? Future<void>.delayed,
      ),
    );
  }

  LocalServer._(this._auth, this._checkout, this._orders);

  final AuthResolvers _auth;
  final CatalogResolvers _catalog = CatalogResolvers();
  final CheckoutResolvers _checkout;
  final OrderResolvers _orders;

  late final Map<String, Resolver> resolvers = {
    'SignIn': (variables, context) async =>
        (await _auth.signIn(Variables$Mutation$SignIn.fromJson(variables)))
            .toJson(),
    'Viewer': (variables, context) async =>
        (await _auth.viewer(context)).toJson(),
    'Bags': (variables, context) async => (await _catalog.bags()).toJson(),
    'CreateCheckoutSession': (variables, context) async =>
        (await _checkout.createSession(context)).toJson(),
    'CheckoutSession': (variables, context) async =>
        (await _checkout.checkoutSession(
          Variables$Query$CheckoutSession.fromJson(variables),
          context,
        )).toJson(),
    'SetPaymentMethod': (variables, context) async =>
        (await _checkout.setPaymentMethod(
          Variables$Mutation$SetPaymentMethod.fromJson(variables),
          context,
        )).toJson(),
    'ConfirmCheckout': (variables, context) async =>
        (await _checkout.confirmCheckout(
          Variables$Mutation$ConfirmCheckout.fromJson(variables),
          context,
        )).toJson(),
    'Order': (variables, context) async => (await _orders.order(
      Variables$Query$Order.fromJson(variables),
      context,
    )).toJson(),
  };

  late final Map<String, StreamResolver> streams = {
    'OrderStatusChanged': (variables, context) => _orders
        .orderStatusChanged(
          Variables$Subscription$OrderStatusChanged.fromJson(variables),
          context,
        )
        .map((event) => event.toJson()),
  };
}
