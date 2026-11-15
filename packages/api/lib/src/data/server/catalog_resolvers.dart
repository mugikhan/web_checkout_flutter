import '../graphql/catalog.graphql.dart';

/// CatalogResolvers answers the bags query from the seeded catalog.
class CatalogResolvers {
  static const _store = (id: 'store_corner_pantry', name: 'Corner Pantry');

  static const _bags = [
    (
      id: 'bag_grocery',
      name: 'Grocery bag',
      description:
          'Fruit, vegetables and pantry staples near their best-before date.',
      priceCents: 7999,
      worthCents: 24000,
    ),
    (
      id: 'bag_cafe',
      name: 'Café bag',
      description: 'Sandwiches, salads and a drink from the café counter.',
      priceCents: 5999,
      worthCents: 18000,
    ),
    (
      id: 'bag_bakery',
      name: 'Bakery bag',
      description: 'Bread, rolls and pastries baked this morning.',
      priceCents: 4999,
      worthCents: 15000,
    ),
    (
      id: 'bag_surprise',
      name: 'Surprise bag',
      description: 'A mix from every counter. The contents change daily.',
      priceCents: 6999,
      worthCents: 21000,
    ),
  ];

  static String get storeName => _store.name;

  /// bag finds a seeded bag by id, or returns null for an unknown id.
  static ({String id, String name, int priceCents})? bag(String id) {
    for (final bag in _bags) {
      if (bag.id == id) {
        return (id: bag.id, name: bag.name, priceCents: bag.priceCents);
      }
    }
    return null;
  }

  Future<Query$Bags> bags() async => Query$Bags(
    bags: [
      for (final bag in _bags)
        Fragment$BagFields(
          id: bag.id,
          name: bag.name,
          description: bag.description,
          priceCents: bag.priceCents,
          worthCents: bag.worthCents,
          store: Fragment$BagFields$store(id: _store.id, name: _store.name),
        ),
    ],
  );
}
