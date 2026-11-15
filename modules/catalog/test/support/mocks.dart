import 'package:api/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

const cornerPantry = Store(id: 'store_corner_pantry', name: 'Corner Pantry');

const grocery = Bag(
  id: 'bag_grocery',
  name: 'Grocery bag',
  description: 'Fruit, vegetables and pantry staples.',
  price: Money(7999),
  worth: Money(24000),
  store: cornerPantry,
);

const cafe = Bag(
  id: 'bag_cafe',
  name: 'Café bag',
  description: 'Sandwiches, salads and a drink.',
  price: Money(5999),
  worth: Money(18000),
  store: cornerPantry,
);

const bakery = Bag(
  id: 'bag_bakery',
  name: 'Bakery bag',
  description: 'Bread, rolls and pastries.',
  price: Money(4999),
  worth: Money(15000),
  store: cornerPantry,
);

const surprise = Bag(
  id: 'bag_surprise',
  name: 'Surprise bag',
  description: 'A mix from every counter.',
  price: Money(6999),
  worth: Money(21000),
  store: cornerPantry,
);

const allBags = [grocery, cafe, bakery, surprise];
