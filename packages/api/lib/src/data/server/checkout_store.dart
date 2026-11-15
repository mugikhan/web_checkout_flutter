import 'dart:convert';

import 'package:storage/storage.dart';

/// StoredSession is a checkout session as the "server" keeps it.
class StoredSession {
  const StoredSession({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    required this.expiresAt,
    this.cardId,
    this.orderId,
  });

  factory StoredSession.fromJson(Map<String, dynamic> json) => StoredSession(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    cardId: json['cardId'] as String?,
    orderId: json['orderId'] as String?,
  );

  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? cardId;
  final String? orderId;

  StoredSession copyWith({String? cardId, String? orderId}) => StoredSession(
    id: id,
    ownerId: ownerId,
    createdAt: createdAt,
    expiresAt: expiresAt,
    cardId: cardId ?? this.cardId,
    orderId: orderId ?? this.orderId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'cardId': cardId,
    'orderId': orderId,
  };
}

/// CheckoutStore keeps checkout sessions and orders in the server namespace.
class CheckoutStore {
  CheckoutStore(this._store);

  static const sessionsKey = 'checkout_sessions';
  static const ordersKey = 'orders';

  final KeyValueStore _store;

  Future<StoredSession?> session(String id) async {
    final json = (await _read(sessionsKey))[id];
    return json == null
        ? null
        : StoredSession.fromJson(json as Map<String, dynamic>);
  }

  Future<void> saveSession(StoredSession session) =>
      _put(sessionsKey, session.id, session.toJson());

  Future<Map<String, dynamic>?> order(String id) async =>
      (await _read(ordersKey))[id] as Map<String, dynamic>?;

  Future<List<Map<String, dynamic>>> orders() async => [
    for (final order in (await _read(ordersKey)).values)
      order as Map<String, dynamic>,
  ];

  Future<void> saveOrder(Map<String, dynamic> order) =>
      _put(ordersKey, order['id'] as String, order);

  Future<void> _put(String key, String id, Map<String, dynamic> value) async {
    final all = await _read(key);
    all[id] = value;
    await _store.write(key, jsonEncode(all));
  }

  Future<Map<String, dynamic>> _read(String key) async {
    final raw = await _store.read(key);
    return raw == null ? {} : jsonDecode(raw) as Map<String, dynamic>;
  }
}
