import 'package:storage/storage.dart';

/// TokenStore keeps the viewer's token in the client namespace.
class TokenStore {
  const TokenStore(this._store);

  static const _key = 'auth.token';

  final KeyValueStore _store;

  Future<String?> read() => _store.read(_key);
  Future<void> write(String token) => _store.write(_key, token);
  Future<void> delete() => _store.delete(_key);
}
