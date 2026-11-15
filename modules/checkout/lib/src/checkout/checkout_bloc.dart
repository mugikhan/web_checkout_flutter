import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'checkout_event.dart';
import 'checkout_state.dart';

/// CheckoutBloc runs one checkout session: the draft, the card and confirm.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({
    required this._checkoutRepository,
    required this._catalogRepository,
    this._clock = DateTime.now,
  }) : super(const CheckoutState()) {
    on<CheckoutLoadRequested>(_onLoadRequested, transformer: restartable());
    on<CheckoutLinkChanged>(
      (event, emit) => emit(
        _withLink(
          state.copyWith(linkIds: event.bagIds, linkSlot: () => event.slot),
        ),
      ),
    );
    on<CheckoutCardPicked>(_onCardPicked, transformer: restartable());
    on<CheckoutConfirmRequested>(_onConfirmRequested, transformer: droppable());
    on<CheckoutErrorDismissed>(
      (event, emit) => emit(state.copyWith(error: () => null)),
    );
  }

  final CheckoutRepository _checkoutRepository;
  final CatalogRepository _catalogRepository;
  final DateTime Function() _clock;

  Future<void> _onLoadRequested(
    CheckoutLoadRequested event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CheckoutStatus.loading,
        sessionId: event.sessionId,
        error: () => null,
      ),
    );
    final (session, bags) = await (
      _checkoutRepository.session(event.sessionId),
      _catalogRepository.bags(),
    ).wait;
    final now = _clock();
    final loaded = state.copyWith(
      today: DateTime(now.year, now.month, now.day),
    );
    emit(switch (session) {
      SessionNotFound() => loaded.copyWith(status: CheckoutStatus.notFound),
      CheckoutUnavailable() => loaded.copyWith(status: CheckoutStatus.failed),
      CheckoutSessionLoaded(:final session, :final savedCards) =>
        switch (bags) {
          BagsLoaded(:final bags) => _fromSession(
            loaded.copyWith(bags: bags, savedCards: savedCards),
            session,
          ),
          BagsUnavailable() when session.status == CheckoutSessionStatus.open =>
            loaded.copyWith(status: CheckoutStatus.failed),
          BagsUnavailable() => _fromSession(loaded, session),
        },
    });
  }

  Future<void> _onCardPicked(
    CheckoutCardPicked event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.status != CheckoutStatus.ready || state.confirming) return;
    emit(
      state.copyWith(
        pendingCardId: () => event.cardId,
        error: () => _keepSlotError(state.error),
      ),
    );
    final result = await _checkoutRepository.setPaymentMethod(
      state.sessionId,
      event.cardId,
    );
    final settled = state.copyWith(pendingCardId: () => null);
    emit(switch (result) {
      PaymentMethodSet(:final session) => _fromSession(settled, session),
      SessionNotFound() => settled.copyWith(status: CheckoutStatus.notFound),
      SessionExpired() => settled.copyWith(status: CheckoutStatus.expired),
      CardNotFound() || CheckoutUnavailable() => settled.copyWith(
        error: () => CheckoutError.cardFailed,
      ),
    });
  }

  Future<void> _onConfirmRequested(
    CheckoutConfirmRequested event,
    Emitter<CheckoutState> emit,
  ) async {
    if (!state.canConfirm) return;
    emit(state.copyWith(confirming: true, error: () => null));
    final result = await _checkoutRepository.confirm(
      state.sessionId,
      state.picked,
      state.window!.start,
    );
    final failed = state.copyWith(confirming: false);
    switch (result) {
      case CheckoutConfirmed(:final orderId):
        emit(
          state.copyWith(status: CheckoutStatus.completed, orderId: orderId),
        );
      case SessionNotFound():
        emit(failed.copyWith(status: CheckoutStatus.notFound));
      case SessionExpired():
        emit(failed.copyWith(status: CheckoutStatus.expired));
      case SlotUnavailable():
        emit(
          failed.copyWith(
            window: () => null,
            error: () => CheckoutError.slotUnavailable,
          ),
        );
        await _reloadSession(emit);
      case PaymentMethodMissing():
        emit(
          failed.copyWith(
            cardId: () => null,
            error: () => CheckoutError.paymentMissing,
          ),
        );
      case InvalidBags():
        emit(failed.copyWith(error: () => CheckoutError.invalidBags));
      case CheckoutUnavailable():
        emit(failed.copyWith(error: () => CheckoutError.confirmFailed));
    }
  }

  Future<void> _reloadSession(Emitter<CheckoutState> emit) async {
    final result = await _checkoutRepository.session(state.sessionId);
    switch (result) {
      case CheckoutSessionLoaded(:final session):
        emit(_fromSession(state, session));
      case SessionNotFound():
        emit(state.copyWith(status: CheckoutStatus.notFound));
      case CheckoutUnavailable():
        break;
    }
  }

  static CheckoutState _fromSession(
    CheckoutState state,
    CheckoutSession session,
  ) => switch (session.status) {
    CheckoutSessionStatus.completed => state.copyWith(
      status: CheckoutStatus.completed,
      orderId: session.orderId,
    ),
    CheckoutSessionStatus.expired => state.copyWith(
      status: CheckoutStatus.expired,
    ),
    CheckoutSessionStatus.open => _withLink(
      state.copyWith(
        status: CheckoutStatus.ready,
        windows: session.windows,
        cardId: () => session.paymentMethod?.id,
      ),
    ),
  };

  static CheckoutState _withLink(CheckoutState state) {
    if (state.status != CheckoutStatus.ready) return state;
    final known = {for (final bag in state.bags) bag.id};
    final start = CollectionWindow.parseSlot(state.linkSlot);
    final window = state.windows.where((w) => w.start == start).firstOrNull;
    final stale = state.linkSlot != null && window == null;
    return state.copyWith(
      picked: BagSelection.clean(state.linkIds, known),
      window: () => window,
      error: () => switch (state.error) {
        _ when stale => CheckoutError.slotUnavailable,
        CheckoutError.slotUnavailable when window != null => null,
        final error => error,
      },
    );
  }

  // The slot notice stays until the customer picks a new window.
  static CheckoutError? _keepSlotError(CheckoutError? error) =>
      error == CheckoutError.slotUnavailable ? error : null;
}
