import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'checkout_start_event.dart';
import 'checkout_start_state.dart';

/// CheckoutStartBloc creates the checkout session that `/checkout/new` opens.
class CheckoutStartBloc extends Bloc<CheckoutStartEvent, CheckoutStartState> {
  CheckoutStartBloc({required this._checkoutRepository})
    : super(const CheckoutStartState()) {
    on<CheckoutStartRequested>(_onStartRequested, transformer: droppable());
  }

  final CheckoutRepository _checkoutRepository;

  Future<void> _onStartRequested(
    CheckoutStartRequested event,
    Emitter<CheckoutStartState> emit,
  ) async {
    emit(const CheckoutStartState());
    final result = await _checkoutRepository.createSession();
    emit(switch (result) {
      CheckoutStarted(:final sessionId) => CheckoutStartState(
        status: CheckoutStartStatus.started,
        sessionId: sessionId,
      ),
      CheckoutUnavailable() => const CheckoutStartState(
        status: CheckoutStartStatus.failed,
      ),
    });
  }
}
