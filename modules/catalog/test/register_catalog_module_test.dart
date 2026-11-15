import 'package:api/domain/domain.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'support/mocks.dart';

void main() {
  test('registers a fresh bloc per lookup', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton<CatalogRepository>(MockCatalogRepository());

    registerCatalogModule(sl);

    expect(sl<CatalogBloc>(), isNot(same(sl<CatalogBloc>())));
  });
}
