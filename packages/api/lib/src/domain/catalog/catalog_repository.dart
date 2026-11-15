import 'bags_result.dart';

/// CatalogRepository loads the bags the store sells.
abstract interface class CatalogRepository {
  Future<BagsResult> bags();
}
