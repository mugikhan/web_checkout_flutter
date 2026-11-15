import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_checkout/app.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCatalogRepository extends Mock implements CatalogRepository {}

const _store = Store(id: 'store_corner_pantry', name: 'Corner Pantry');

/// seededBags mirrors the "server" catalog in the order it returns.
const seededBags = [
  Bag(
    id: 'bag_grocery',
    name: 'Grocery bag',
    description: 'Fruit, vegetables and pantry staples.',
    price: Money(7999),
    worth: Money(24000),
    store: _store,
  ),
  Bag(
    id: 'bag_cafe',
    name: 'Café bag',
    description: 'Sandwiches, salads and a drink.',
    price: Money(5999),
    worth: Money(18000),
    store: _store,
  ),
  Bag(
    id: 'bag_bakery',
    name: 'Bakery bag',
    description: 'Bread, rolls and pastries.',
    price: Money(4999),
    worth: Money(15000),
    store: _store,
  ),
  Bag(
    id: 'bag_surprise',
    name: 'Surprise bag',
    description: 'A mix from every counter.',
    price: Money(6999),
    worth: Money(21000),
    store: _store,
  ),
];

/// mockCatalogRepository stubs a repository that returns [seededBags].
MockCatalogRepository mockCatalogRepository() {
  final repository = MockCatalogRepository();
  when(() => repository.bags())
      .thenAnswer((_) async => const BagsLoaded(seededBags));
  return repository;
}

const naledi = Viewer(id: 'viewer:naledi', name: 'Naledi');

/// mockAuthRepository stubs a repository that starts with [viewer] signed in.
MockAuthRepository mockAuthRepository({Viewer? viewer}) {
  final repository = MockAuthRepository();
  when(() => repository.currentViewer()).thenAnswer((_) async => viewer);
  when(() => repository.signIn(any()))
      .thenAnswer((_) async => const SignedIn(naledi));
  when(() => repository.signOut()).thenAnswer((_) async {});
  return repository;
}

/// pumpApp starts the app at [location]; pass `settle: false` while a spinner shows.
Future<void> pumpApp(
  WidgetTester tester, {
  String location = '/',
  Size size = const Size(400, 800),
  AuthRepository? repository,
  CatalogRepository? catalog,
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final sl = GetIt.asNewInstance()
    ..registerSingleton<AuthRepository>(repository ?? mockAuthRepository())
    ..registerSingleton<CatalogRepository>(catalog ?? mockCatalogRepository());
  registerAuthModule(sl);
  registerCatalogModule(sl);

  await tester.pumpWidget(
    BagCheckoutApp(
      sl: sl,
      initialLocation: location,
      textTheme: ThemeData().textTheme,
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

/// currentLocation reads the router's current URI.
String currentLocation(WidgetTester tester) {
  final context = tester.element(find.byType(Navigator).first);
  return GoRouter.of(context).routerDelegate.currentConfiguration.uri
      .toString();
}
