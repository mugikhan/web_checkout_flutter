import 'package:api/data/data.dart';
import 'package:api/src/data/graphql/catalog.graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  Future<Query$Bags> bags() async => Query$Bags.fromJson(
    await LocalServer(MemoryStore())
        .resolvers['Bags']!({}, const RequestContext()),
  );

  test('bags returns the four seeded bags in catalog order', () async {
    final result = await bags();

    expect(result.bags.map((b) => b.id), [
      'bag_grocery',
      'bag_cafe',
      'bag_bakery',
      'bag_surprise',
    ]);
  });

  test(
    'every bag costs less than its worth and comes from Corner Pantry',
    () async {
      for (final bag in (await bags()).bags) {
        expect(bag.priceCents, lessThan(bag.worthCents), reason: bag.id);
        expect(bag.store.name, 'Corner Pantry');
        expect(bag.description, isNotEmpty);
      }
    },
  );

  test('bags needs no viewer', () async {
    final cafe = (await bags()).bags.firstWhere((b) => b.id == 'bag_cafe');

    expect(cafe.name, 'Café bag');
    expect(cafe.priceCents, 5999);
    expect(cafe.worthCents, 18000);
  });
}
