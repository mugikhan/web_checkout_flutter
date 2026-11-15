import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:storage/storage.dart';

void main() {
  test('registers an AuthRepository over AppStorage', () async {
    final sl = GetIt.asNewInstance()
      ..registerSingleton(
        AppStorage(client: MemoryStore(), server: MemoryStore()),
      );

    registerApiData(sl);

    expect(sl<AuthRepository>(), isA<GraphqlAuthRepository>());
    expect(await sl<AuthRepository>().currentViewer(), isNull);
  });

  test('registers a CatalogRepository', () async {
    final sl = GetIt.asNewInstance()
      ..registerSingleton(
        AppStorage(client: MemoryStore(), server: MemoryStore()),
      );

    registerApiData(sl);

    expect(sl<CatalogRepository>(), isA<GraphqlCatalogRepository>());
    expect(await sl<CatalogRepository>().bags(), isA<BagsLoaded>());
  });

  test('registers a CheckoutRepository', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton(
        AppStorage(client: MemoryStore(), server: MemoryStore()),
      );

    registerApiData(sl);

    expect(sl<CheckoutRepository>(), isA<GraphqlCheckoutRepository>());
  });

  test('registers an OrderRepository', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton(
        AppStorage(client: MemoryStore(), server: MemoryStore()),
      );

    registerApiData(sl);

    expect(sl<OrderRepository>(), isA<GraphqlOrderRepository>());
  });
}
