import 'package:api/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

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

const allBags = [grocery, cafe, bakery];

const visa = SavedCard(id: 'card_visa_4242', brand: 'Visa', last4: '4242');
const mastercard = SavedCard(
  id: 'card_mastercard_0002',
  brand: 'Mastercard',
  last4: '0002',
);
const savedCards = [visa, mastercard];

/// now is 12:30 local time, so today offers 13:00 to 21:00.
final now = DateTime(2026, 11, 15, 12, 30);
final windows = CollectionWindow.offered(now);
final firstWindow = windows.first;
final secondWindow = windows[1];

CheckoutSession openSession({SavedCard? card}) => CheckoutSession(
  id: 'cs_1',
  status: CheckoutSessionStatus.open,
  expiresAt: now.add(const Duration(minutes: 15)).toUtc(),
  paymentMethod: card,
  windows: windows,
);

final expiredSession = CheckoutSession(
  id: 'cs_1',
  status: CheckoutSessionStatus.expired,
  expiresAt: now.toUtc(),
);

final completedSession = CheckoutSession(
  id: 'cs_1',
  status: CheckoutSessionStatus.completed,
  expiresAt: now.toUtc(),
  orderId: 'ord_1',
  paymentMethod: visa,
);
