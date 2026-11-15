import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart' hide Store;
import 'package:storage/storage.dart';

void main() {
  CatalogRepository build(Link link) => GraphqlCatalogRepository(
    client: GraphQLClient(link: link, cache: GraphQLCache()),
  );

  test('bags maps the seeded catalog to domain bags', () async {
    final repository = GraphqlCatalogRepository(
      client: buildGraphqlClient(
        tokens: TokenStore(MemoryStore()),
        server: LocalServer(MemoryStore()),
      ),
    );

    final result = await repository.bags();

    final bags = (result as BagsLoaded).bags;
    expect(bags.map((b) => b.id), [
      'bag_grocery',
      'bag_cafe',
      'bag_bakery',
      'bag_surprise',
    ]);
    expect(
      bags[1],
      const Bag(
        id: 'bag_cafe',
        name: 'Café bag',
        description: 'Sandwiches, salads and a drink from the café counter.',
        price: Money(5999),
        worth: Money(18000),
        store: Store(id: 'store_corner_pantry', name: 'Corner Pantry'),
      ),
    );
  });

  test('a GraphQL error maps to BagsUnavailable', () async {
    expect(await build(LocalLink({})).bags(), const BagsUnavailable());
  });

  test('a failing resolver maps to BagsUnavailable', () async {
    final link = LocalLink({
      'Bags': (variables, context) async => throw StateError('boom'),
    });

    expect(await build(link).bags(), const BagsUnavailable());
  });
}
