import 'checkout_results.dart';

/// CheckoutRepository runs a checkout session on the "server".
abstract interface class CheckoutRepository {
  Future<StartCheckoutResult> createSession();

  /// session also returns the viewer's saved cards.
  Future<CheckoutSessionResult> session(String id);

  Future<SetPaymentMethodResult> setPaymentMethod(
    String sessionId,
    String cardId,
  );

  Future<ConfirmCheckoutResult> confirm(
    String sessionId,
    List<String> bagIds,
    DateTime slotStart,
  );
}
