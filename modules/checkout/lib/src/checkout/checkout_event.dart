sealed class CheckoutEvent {
  const CheckoutEvent();
}

final class CheckoutLoadRequested extends CheckoutEvent {
  const CheckoutLoadRequested(this.sessionId);

  final String sessionId;
}

/// CheckoutLinkChanged carries the bag ids and slot the URL holds now, as written.
final class CheckoutLinkChanged extends CheckoutEvent {
  const CheckoutLinkChanged(this.bagIds, this.slot);

  final List<String> bagIds;
  final String? slot;
}

final class CheckoutCardPicked extends CheckoutEvent {
  const CheckoutCardPicked(this.cardId);

  final String cardId;
}

final class CheckoutConfirmRequested extends CheckoutEvent {
  const CheckoutConfirmRequested();
}

final class CheckoutErrorDismissed extends CheckoutEvent {
  const CheckoutErrorDismissed();
}
