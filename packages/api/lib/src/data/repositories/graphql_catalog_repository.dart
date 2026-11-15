import 'package:graphql/client.dart' show GraphQLClient;

import '../../domain/catalog/bag.dart';
import '../../domain/catalog/bags_result.dart';
import '../../domain/catalog/catalog_repository.dart';
import '../../domain/catalog/money.dart';
import '../../domain/catalog/store.dart';
import '../graphql/catalog.graphql.dart';

/// GraphqlCatalogRepository implements [CatalogRepository] over the GraphQL client.
class GraphqlCatalogRepository implements CatalogRepository {
  GraphqlCatalogRepository({required this._client});

  final GraphQLClient _client;

  @override
  Future<BagsResult> bags() async {
    final result = await _client.query$Bags();
    final data = result.parsedData;
    if (result.hasException || data == null) return const BagsUnavailable();
    return BagsLoaded([for (final bag in data.bags) _toBag(bag)]);
  }

  static Bag _toBag(Fragment$BagFields fields) => Bag(
    id: fields.id,
    name: fields.name,
    description: fields.description,
    price: Money(fields.priceCents),
    worth: Money(fields.worthCents),
    store: Store(id: fields.store.id, name: fields.store.name),
  );
}
