import 'package:api/domain/domain.dart';
import 'package:flutter/foundation.dart';

enum CheckoutStatus { loading, ready, completed, notFound, expired, failed }

/// CheckoutError is a recoverable problem the page shows as a notice.
enum CheckoutError {
  cardFailed,
  slotUnavailable,
  paymentMissing,
  invalidBags,
  confirmFailed,
}

/// CheckoutState holds the session, the draft from the URL and the request flags.
class CheckoutState {
  const CheckoutState({
    this.status = CheckoutStatus.loading,
    this.sessionId = '',
    this.bags = const [],
    this.savedCards = const [],
    this.windows = const [],
    this.today,
    this.linkIds = const [],
    this.linkSlot,
    this.picked = const [],
    this.window,
    this.cardId,
    this.pendingCardId,
    this.confirming = false,
    this.error,
    this.orderId,
  });

  final CheckoutStatus status;
  final String sessionId;

  /// bags holds every bag the store sells, to look up the picks.
  final List<Bag> bags;
  final List<SavedCard> savedCards;
  final List<CollectionWindow> windows;

  /// today is the local date at load, which labels the window groups.
  final DateTime? today;

  /// linkIds holds the bag ids from the URL, before cleaning.
  final List<String> linkIds;

  /// linkSlot holds the slot from the URL, before matching.
  final String? linkSlot;

  /// picked holds the clean bag ids once [status] is ready.
  final List<String> picked;

  /// window is the offered window that matches [linkSlot].
  final CollectionWindow? window;

  /// cardId is the card the "server" holds on the session.
  final String? cardId;

  /// pendingCardId is the card whose request is running.
  final String? pendingCardId;
  final bool confirming;
  final CheckoutError? error;

  /// orderId is set once the session is completed.
  final String? orderId;

  List<Bag> get pickedBags => [
    for (final id in picked) bags.firstWhere((bag) => bag.id == id),
  ];

  Money get total => pickedBags.fold(Money.zero, (sum, bag) => sum + bag.price);

  bool get canConfirm =>
      status == CheckoutStatus.ready &&
      picked.isNotEmpty &&
      window != null &&
      cardId != null &&
      pendingCardId == null &&
      !confirming;

  /// needsCleanUrl is true when the URL holds bags or a slot the page dropped.
  bool get needsCleanUrl =>
      status == CheckoutStatus.ready &&
      (!listEquals(linkIds, picked) || linkSlot != window?.slotParam);

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? sessionId,
    List<Bag>? bags,
    List<SavedCard>? savedCards,
    List<CollectionWindow>? windows,
    DateTime? today,
    List<String>? linkIds,
    ValueGetter<String?>? linkSlot,
    List<String>? picked,
    ValueGetter<CollectionWindow?>? window,
    ValueGetter<String?>? cardId,
    ValueGetter<String?>? pendingCardId,
    bool? confirming,
    ValueGetter<CheckoutError?>? error,
    String? orderId,
  }) => CheckoutState(
    status: status ?? this.status,
    sessionId: sessionId ?? this.sessionId,
    bags: bags ?? this.bags,
    savedCards: savedCards ?? this.savedCards,
    windows: windows ?? this.windows,
    today: today ?? this.today,
    linkIds: linkIds ?? this.linkIds,
    linkSlot: linkSlot != null ? linkSlot() : this.linkSlot,
    picked: picked ?? this.picked,
    window: window != null ? window() : this.window,
    cardId: cardId != null ? cardId() : this.cardId,
    pendingCardId: pendingCardId != null ? pendingCardId() : this.pendingCardId,
    confirming: confirming ?? this.confirming,
    error: error != null ? error() : this.error,
    orderId: orderId ?? this.orderId,
  );

  @override
  bool operator ==(Object other) =>
      other is CheckoutState &&
      other.status == status &&
      other.sessionId == sessionId &&
      listEquals(other.bags, bags) &&
      listEquals(other.savedCards, savedCards) &&
      listEquals(other.windows, windows) &&
      other.today == today &&
      listEquals(other.linkIds, linkIds) &&
      other.linkSlot == linkSlot &&
      listEquals(other.picked, picked) &&
      other.window == window &&
      other.cardId == cardId &&
      other.pendingCardId == pendingCardId &&
      other.confirming == confirming &&
      other.error == error &&
      other.orderId == orderId;

  @override
  int get hashCode => Object.hash(
    status,
    sessionId,
    Object.hashAll(bags),
    Object.hashAll(savedCards),
    Object.hashAll(windows),
    today,
    Object.hashAll(linkIds),
    linkSlot,
    Object.hashAll(picked),
    window,
    cardId,
    pendingCardId,
    confirming,
    error,
    orderId,
  );

  @override
  String toString() =>
      'CheckoutState(${status.name}, $sessionId, link $linkIds $linkSlot, '
      'picked $picked $window, card $cardId pending $pendingCardId, '
      'confirming $confirming, error $error, order $orderId)';
}
