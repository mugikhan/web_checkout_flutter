import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:storage/storage.dart';

import '../domain/auth/auth_repository.dart';
import '../domain/catalog/catalog_repository.dart';
import 'graphql_client.dart';
import 'repositories/graphql_auth_repository.dart';
import 'repositories/graphql_catalog_repository.dart';
import 'repositories/token_store.dart';
import 'server/local_server.dart';

/// registerApiData registers the GraphQL client, the "server" and repositories.
void registerApiData(GetIt sl) {
  final storage = sl<AppStorage>();
  sl
    ..registerLazySingleton(() => TokenStore(storage.client))
    ..registerLazySingleton(() => LocalServer(storage.server))
    ..registerLazySingleton<GraphQLClient>(
      () => buildGraphqlClient(tokens: sl(), server: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => GraphqlAuthRepository(client: sl(), tokens: sl()),
    )
    ..registerLazySingleton<CatalogRepository>(
      () => GraphqlCatalogRepository(client: sl()),
    );
}
