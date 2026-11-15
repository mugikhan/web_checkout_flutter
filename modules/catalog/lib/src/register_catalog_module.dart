import 'package:get_it/get_it.dart';

import 'catalog/catalog_bloc.dart';

/// registerCatalogModule registers the catalog bloc; the app registers CatalogRepository first.
void registerCatalogModule(GetIt sl) {
  sl.registerFactory(() => CatalogBloc(catalogRepository: sl()));
}
