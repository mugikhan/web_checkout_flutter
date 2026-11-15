import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'session_event.dart';
import 'session_state.dart';

/// SessionBloc owns the app-wide signed-in or signed-out state.
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required this._authRepository})
    : super(const SessionChecking()) {
    on<SessionCheckRequested>(_onCheckRequested, transformer: droppable());
    on<ViewerSignedIn>((event, emit) => emit(SessionSignedIn(event.viewer)));
    on<SignOutRequested>(_onSignOutRequested, transformer: droppable());
  }

  final AuthRepository _authRepository;

  Future<void> _onCheckRequested(
    SessionCheckRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final viewer = await _authRepository.currentViewer();
      emit(viewer == null ? const SessionSignedOut() : SessionSignedIn(viewer));
    } on ApiFault {
      emit(const SessionSignedOut());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<SessionState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const SessionSignedOut());
  }
}
