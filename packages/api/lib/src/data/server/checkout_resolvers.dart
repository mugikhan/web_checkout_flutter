import 'dart:math';

import '../../domain/catalog/bag_selection.dart';
import '../../domain/checkout/collection_window.dart';
import '../graphql/checkout.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../link/request_context.dart';
import 'auth_resolvers.dart';
import 'catalog_resolvers.dart';
import 'checkout_store.dart';
import 'session_store.dart';

typedef SeededCard = ({String id, String brand, String last4, bool declines});

/// CheckoutResolvers runs checkout sessions and creates at most one order per session.
class CheckoutResolvers {
  CheckoutResolvers({
    required this._viewers,
    required this._store,
    required this._random,
    required this._clock,
  });

  static const sessionLength = Duration(minutes: 15);
  static const holdDelay = Duration(seconds: 3);

  static const List<SeededCard> savedCards = [
    (id: 'card_visa_4242', brand: 'Visa', last4: '4242', declines: false),
    (
      id: 'card_mastercard_0002',
      brand: 'Mastercard',
      last4: '0002',
      declines: true,
    ),
  ];

  final SessionStore _viewers;
  final CheckoutStore _store;
  final Random _random;
  final DateTime Function() _clock;

  Future<void> _tail = Future.value();

  Future<Mutation$CreateCheckoutSession> createSession(
    RequestContext context,
  ) async {
    final ownerId = await _viewerId(context);
    if (ownerId == null) {
      throw StateError('createCheckoutSession needs a viewer.');
    }
    final now = _now();
    final session = StoredSession(
      id: 'cs_${_hex(8)}',
      ownerId: ownerId,
      createdAt: now,
      expiresAt: now.add(sessionLength),
    );
    await _store.saveSession(session);
    return Mutation$CreateCheckoutSession(
      createCheckoutSession:
          Mutation$CreateCheckoutSession$createCheckoutSession(id: session.id),
    );
  }

  Future<Query$CheckoutSession> checkoutSession(
    Variables$Query$CheckoutSession variables,
    RequestContext context,
  ) async {
    final ownerId = await _viewerId(context);
    final session = await _owned(variables.id, ownerId);
    return Query$CheckoutSession(
      checkoutSession: session == null
          ? Query$CheckoutSession$checkoutSession$$SessionNotFound(
              sessionId: variables.id,
            )
          : Query$CheckoutSession$checkoutSession.fromJson(
              _fields(session).toJson(),
            ),
      savedCards: ownerId == null ? [] : savedCards.map(_cardFields).toList(),
    );
  }

  Future<Mutation$SetPaymentMethod> setPaymentMethod(
    Variables$Mutation$SetPaymentMethod variables,
    RequestContext context,
  ) => _serial(() async {
    final session = await _owned(variables.sessionId, await _viewerId(context));
    Mutation$SetPaymentMethod result(
      Mutation$SetPaymentMethod$setPaymentMethod value,
    ) => Mutation$SetPaymentMethod(setPaymentMethod: value);

    if (session == null) {
      return result(
        Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
          sessionId: variables.sessionId,
        ),
      );
    }
    final status = _status(session);
    if (status == Enum$CheckoutSessionStatus.EXPIRED) {
      return result(
        Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
          sessionId: session.id,
        ),
      );
    }
    // A completed session keeps its card; the client sees COMPLETED and moves on.
    var updated = session;
    if (status == Enum$CheckoutSessionStatus.OPEN) {
      if (_card(variables.cardId) == null) {
        return result(
          Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
            cardId: variables.cardId,
          ),
        );
      }
      updated = session.copyWith(cardId: variables.cardId);
      await _store.saveSession(updated);
    }
    return result(
      Mutation$SetPaymentMethod$setPaymentMethod.fromJson(
        _fields(updated).toJson(),
      ),
    );
  });

  Future<Mutation$ConfirmCheckout> confirmCheckout(
    Variables$Mutation$ConfirmCheckout variables,
    RequestContext context,
  ) => _serial(() async {
    Mutation$ConfirmCheckout result(
      Mutation$ConfirmCheckout$confirmCheckout value,
    ) => Mutation$ConfirmCheckout(confirmCheckout: value);

    final session = await _owned(variables.sessionId, await _viewerId(context));
    if (session == null) {
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
          sessionId: variables.sessionId,
        ),
      );
    }
    // Check completion first, so a repeat with stale arguments still gets its order.
    final existingId = session.orderId;
    if (existingId != null) {
      final order = (await _store.order(existingId))!;
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$Order(
          id: existingId,
          status: fromJson$Enum$OrderStatus(order['status'] as String),
        ),
      );
    }
    if (_status(session) == Enum$CheckoutSessionStatus.EXPIRED) {
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
          sessionId: session.id,
        ),
      );
    }
    final bags = _bags(variables.bagIds);
    if (bags == null) {
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
          maxBags: BagSelection.maxBags,
        ),
      );
    }
    final window = _offeredWindow(variables.slotStart);
    if (window == null) {
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
          slotStart: variables.slotStart,
        ),
      );
    }
    final card = session.cardId == null ? null : _card(session.cardId!);
    if (card == null) {
      return result(
        Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
          sessionId: session.id,
        ),
      );
    }

    final now = _now();
    final orderId = 'ord_${_hex(6)}';
    await _store.saveOrder({
      'id': orderId,
      'ownerId': session.ownerId,
      'sessionId': session.id,
      'status': toJson$Enum$OrderStatus(Enum$OrderStatus.CREATED),
      'createdAt': now.toIso8601String(),
      'holdConfirmsAt': now.add(holdDelay).toIso8601String(),
      'declines': card.declines,
      'store': CatalogResolvers.storeName,
      'bags': [
        for (final bag in bags)
          {'id': bag.id, 'name': bag.name, 'priceCents': bag.priceCents},
      ],
      'totalCents': bags.fold<int>(0, (sum, bag) => sum + bag.priceCents),
      'window': {
        'startsAt': window.start.toIso8601String(),
        'endsAt': window.end.toIso8601String(),
      },
      'paymentMethod': {
        'id': card.id,
        'brand': card.brand,
        'last4': card.last4,
      },
    });
    await _store.saveSession(session.copyWith(orderId: orderId));
    return result(
      Mutation$ConfirmCheckout$confirmCheckout$$Order(
        id: orderId,
        status: Enum$OrderStatus.CREATED,
      ),
    );
  });

  // Run one write at a time, so two confirms cannot both read an open session.
  Future<T> _serial<T>(Future<T> Function() task) {
    final result = _tail.then((_) => task());
    _tail = result.then((_) {}, onError: (_) {});
    return result;
  }

  DateTime _now() => _clock().toUtc();

  Future<String?> _viewerId(RequestContext context) async {
    final token = context.token;
    final name = token == null ? null : await _viewers.nameFor(token);
    return name == null ? null : AuthResolvers.viewerId(name);
  }

  Future<StoredSession?> _owned(String id, String? ownerId) async {
    if (ownerId == null) return null;
    final session = await _store.session(id);
    return session?.ownerId == ownerId ? session : null;
  }

  Enum$CheckoutSessionStatus _status(StoredSession session) {
    if (session.orderId != null) return Enum$CheckoutSessionStatus.COMPLETED;
    if (!_now().isBefore(session.expiresAt)) {
      return Enum$CheckoutSessionStatus.EXPIRED;
    }
    return Enum$CheckoutSessionStatus.OPEN;
  }

  Fragment$CheckoutSessionFields _fields(StoredSession session) {
    final status = _status(session);
    final card = session.cardId == null ? null : _card(session.cardId!);
    return Fragment$CheckoutSessionFields(
      id: session.id,
      status: status,
      expiresAt: session.expiresAt.toIso8601String(),
      orderId: session.orderId,
      paymentMethod: card == null ? null : _cardFields(card),
      collectionWindows: status == Enum$CheckoutSessionStatus.OPEN
          ? [
              for (final window in CollectionWindow.offered(_clock()))
                Fragment$CheckoutSessionFields$collectionWindows(
                  startsAt: window.start.toIso8601String(),
                  endsAt: window.end.toIso8601String(),
                ),
            ]
          : [],
    );
  }

  CollectionWindow? _offeredWindow(String slotStart) {
    final start = CollectionWindow.parseSlot(slotStart);
    if (start == null) return null;
    for (final window in CollectionWindow.offered(_clock())) {
      if (window.start == start) return window;
    }
    return null;
  }

  static List<({String id, String name, int priceCents})>? _bags(
    List<String> ids,
  ) {
    if (ids.isEmpty || ids.length > BagSelection.maxBags) return null;
    if (ids.toSet().length != ids.length) return null;
    final bags = ids.map(CatalogResolvers.bag).toList();
    if (bags.contains(null)) return null;
    return bags.nonNulls.toList();
  }

  static SeededCard? _card(String id) {
    for (final card in savedCards) {
      if (card.id == id) return card;
    }
    return null;
  }

  static Fragment$SavedCardFields _cardFields(SeededCard card) =>
      Fragment$SavedCardFields(
        id: card.id,
        brand: card.brand,
        last4: card.last4,
      );

  String _hex(int bytes) => List.generate(
    bytes,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
