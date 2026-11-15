enum CheckoutStartStatus { starting, started, failed }

/// CheckoutStartState tracks the request that creates a checkout session.
class CheckoutStartState {
  const CheckoutStartState({
    this.status = CheckoutStartStatus.starting,
    this.sessionId,
  });

  final CheckoutStartStatus status;

  /// sessionId is set once [status] is started.
  final String? sessionId;

  @override
  bool operator ==(Object other) =>
      other is CheckoutStartState &&
      other.status == status &&
      other.sessionId == sessionId;

  @override
  int get hashCode => Object.hash(status, sessionId);

  @override
  String toString() => 'CheckoutStartState(${status.name}, $sessionId)';
}
