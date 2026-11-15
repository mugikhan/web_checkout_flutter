import 'dart:math';

import 'package:storage/storage.dart';

import '../graphql/auth.graphql.dart';
import '../link/local_link.dart';
import 'auth_resolvers.dart';
import 'session_store.dart';

/// LocalServer is the in-app "server": one resolver per GraphQL operation.
class LocalServer {
  LocalServer(KeyValueStore store, {Random? random})
    : _auth = AuthResolvers(SessionStore(store, random: random));

  final AuthResolvers _auth;

  late final Map<String, Resolver> resolvers = {
    'SignIn': (variables, context) async =>
        (await _auth.signIn(Variables$Mutation$SignIn.fromJson(variables)))
            .toJson(),
    'Viewer': (variables, context) async =>
        (await _auth.viewer(context)).toJson(),
  };
}
