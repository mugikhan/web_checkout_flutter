import 'package:graphql/client.dart';

import 'link/local_link.dart';
import 'repositories/token_store.dart';
import 'server/local_server.dart';

/// buildGraphqlClient chains the token header onto [LocalLink], with no cache.
GraphQLClient buildGraphqlClient({
  required TokenStore tokens,
  required LocalServer server,
}) {
  final auth = AuthLink(
    getToken: () async {
      final token = await tokens.read();
      return token == null ? null : 'Bearer $token';
    },
  );
  final noCache = Policies(fetch: FetchPolicy.noCache);
  return GraphQLClient(
    link: auth.concat(LocalLink(server.resolvers, streams: server.streams)),
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: noCache,
      mutate: noCache,
      watchQuery: noCache,
    ),
  );
}
