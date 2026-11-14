import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';
import 'shared_preferences_store.dart';

/// AppStorage holds one store for the client and one for the in-app "server".
class AppStorage {
  const AppStorage({required this.client, required this.server});

  final KeyValueStore client;
  final KeyValueStore server;

  static Future<AppStorage> sharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return AppStorage(
      client: SharedPreferencesStore(preferences, namespace: 'client'),
      server: SharedPreferencesStore(preferences, namespace: 'server'),
    );
  }
}
