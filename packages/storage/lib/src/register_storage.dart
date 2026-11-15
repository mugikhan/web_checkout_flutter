import 'package:get_it/get_it.dart';

import 'app_storage.dart';

/// registerStorage registers [AppStorage] over shared_preferences.
Future<void> registerStorage(GetIt sl) async {
  sl.registerSingleton<AppStorage>(await AppStorage.sharedPreferences());
}
