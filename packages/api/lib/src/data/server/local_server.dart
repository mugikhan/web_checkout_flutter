import 'dart:math';

import 'package:storage/storage.dart';

import '../graphql/auth.graphql.dart';
import '../graphql/checkout.graphql.dart';
import '../link/local_link.dart';
import 'auth_resolvers.dart';
import 'catalog_resolvers.dart';
import 'checkout_resolvers.dart';
import 'checkout_store.dart';
import 'session_store.dart';

/// LocalServer is the in-app "server": one resolver per GraphQL operation.
class LocalServer {
  factory LocalServer(
    KeyValueStore store, {
    Random? random,
    DateTime Function()? clock,
  }) {
    final rng = random ?? Random.secure();
    final viewers = SessionStore(store, random: rng);
    return LocalServer._(
      AuthResolvers(viewers),
      CheckoutResolvers(
        viewers: viewers,
        store: CheckoutStore(store),
        random: rng,
        clock: clock ?? DateTime.now,
      ),
    );
  }

  LocalServer._(this._auth, this._checkout);

  final AuthResolvers _auth;
  final CatalogResolvers _catalog = CatalogResolvers();
  final CheckoutResolvers _checkout;

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
  };
}
