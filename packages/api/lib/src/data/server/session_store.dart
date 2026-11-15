import 'dart:convert';
import 'dart:math';

import 'package:storage/storage.dart';

/// SessionStore maps "server" tokens to viewer names in the server namespace.
class SessionStore {
  SessionStore(this._store, {Random? random})
    : _random = random ?? Random.secure();

  static const _key = 'sessions';

  final KeyValueStore _store;
  final Random _random;

  Future<String> create(String name) async {
    final token = List.generate(
      32,
      (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final sessions = await _read();
    sessions[token] = name;
    await _store.write(_key, jsonEncode(sessions));
    return token;
  }

  Future<String?> nameFor(String token) async => (await _read())[token];

  Future<Map<String, String>> _read() async {
    final raw = await _store.read(_key);
    if (raw == null) return {};
    return (jsonDecode(raw) as Map<String, dynamic>).cast<String, String>();
  }
}
