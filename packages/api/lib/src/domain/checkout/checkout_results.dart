import 'package:flutter/foundation.dart';

import 'checkout_session.dart';
import 'saved_card.dart';

/// StartCheckoutResult is the outcome of creating a checkout session.
sealed class StartCheckoutResult {}

/// CheckoutSessionResult is the outcome of reading a checkout session.
sealed class CheckoutSessionResult {}

/// SetPaymentMethodResult is the outcome of storing a card on a session.
sealed class SetPaymentMethodResult {}

/// ConfirmCheckoutResult is the outcome of confirming a checkout session.
sealed class ConfirmCheckoutResult {}

final class CheckoutStarted implements StartCheckoutResult {
  const CheckoutStarted(this.sessionId);

  final String sessionId;

  @override
  bool operator ==(Object other) =>
      other is CheckoutStarted && other.sessionId == sessionId;

  @override
  int get hashCode => sessionId.hashCode;
}

final class CheckoutSessionLoaded implements CheckoutSessionResult {
  const CheckoutSessionLoaded(this.session, this.savedCards);

  final CheckoutSession session;
  final List<SavedCard> savedCards;

  @override
  bool operator ==(Object other) =>
      other is CheckoutSessionLoaded &&
      other.session == session &&
      listEquals(other.savedCards, savedCards);

  @override
  int get hashCode => Object.hash(session, Object.hashAll(savedCards));
}

final class PaymentMethodSet implements SetPaymentMethodResult {
  const PaymentMethodSet(this.session);

  final CheckoutSession session;

  @override
  bool operator ==(Object other) =>
      other is PaymentMethodSet && other.session == session;

  @override
  int get hashCode => session.hashCode;
}

final class CheckoutConfirmed implements ConfirmCheckoutResult {
  const CheckoutConfirmed(this.orderId);

  final String orderId;

  @override
  bool operator ==(Object other) =>
      other is CheckoutConfirmed && other.orderId == orderId;

  @override
  int get hashCode => orderId.hashCode;
}

/// CheckoutFailure is an expected reason a checkout request did not succeed.
sealed class CheckoutFailure {
  const CheckoutFailure();

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// SessionNotFound means the session does not exist or another viewer owns it.
final class SessionNotFound extends CheckoutFailure
    implements
        CheckoutSessionResult,
        SetPaymentMethodResult,
        ConfirmCheckoutResult {
  const SessionNotFound();
}

final class SessionExpired extends CheckoutFailure
    implements SetPaymentMethodResult, ConfirmCheckoutResult {
  const SessionExpired();
}

/// CardNotFound means the viewer has no saved card with that id.
final class CardNotFound extends CheckoutFailure
    implements SetPaymentMethodResult {
  const CardNotFound();
}

/// SlotUnavailable means the slot is not an offered collection window.
final class SlotUnavailable extends CheckoutFailure
    implements ConfirmCheckoutResult {
  const SlotUnavailable();
}

final class PaymentMethodMissing extends CheckoutFailure
    implements ConfirmCheckoutResult {
  const PaymentMethodMissing();
}

/// InvalidBags means the bags are not 1 to 2 distinct known bags.
final class InvalidBags extends CheckoutFailure
    implements ConfirmCheckoutResult {
  const InvalidBags();
}

/// CheckoutUnavailable means the request failed for an unexpected reason.
final class CheckoutUnavailable extends CheckoutFailure
    implements
        StartCheckoutResult,
        CheckoutSessionResult,
        SetPaymentMethodResult,
        ConfirmCheckoutResult {
  const CheckoutUnavailable();
}
