import 'key_value_store.dart';

/// MemoryStore keeps values in memory, for tests and previews.
class MemoryStore implements KeyValueStore {
  MemoryStore([Map<String, String>? values]) : _values = {...?values};

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
