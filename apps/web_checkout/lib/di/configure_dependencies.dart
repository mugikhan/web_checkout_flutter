import 'package:api/data/data.dart';
import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:get_it/get_it.dart';
import 'package:storage/storage.dart';

/// configureDependencies is the composition root: packages first, then modules.
Future<void> configureDependencies(GetIt sl) async {
  // Patrol can call main() twice in one process; start from a clean locator.
  await sl.reset();
  await registerStorage(sl);
  registerApiData(sl);
  registerAuthModule(sl);
  registerCatalogModule(sl);
}
