import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

/// SharedPreferencesStore persists values under a namespace prefix.
class SharedPreferencesStore implements KeyValueStore {
  SharedPreferencesStore(this._preferences, {required String namespace})
    : _prefix = '$namespace.';

  final SharedPreferences _preferences;
  final String _prefix;

  @override
  Future<String?> read(String key) async =>
      _preferences.getString('$_prefix$key');

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString('$_prefix$key', value);

  @override
  Future<void> delete(String key) => _preferences.remove('$_prefix$key');
}
