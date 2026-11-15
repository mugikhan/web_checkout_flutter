import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

/// SignInBloc validates the name and signs the viewer in.
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required this._authRepository}) : super(const SignInState()) {
    on<SignInNameChanged>((event, emit) => emit(SignInState(name: event.name)));
    on<SignInSubmitted>(_onSubmitted, transformer: droppable());
  }

  final AuthRepository _authRepository;

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    final name = state.name;
    if (!ViewerName.isValid(name)) {
      emit(SignInState(name: name, error: SignInError.nameTooShort));
      return;
    }

    emit(SignInState(name: name, status: SignInStatus.submitting));
    final result = await _authRepository.signIn(name.trim());
    emit(switch (result) {
      SignedIn(:final viewer) => SignInState(
        name: name,
        status: SignInStatus.succeeded,
        viewer: viewer,
      ),
      InvalidName(:final minLength) => SignInState(
        name: name,
        error: SignInError.nameTooShort,
        minLength: minLength,
      ),
      SignInUnavailable() => SignInState(
        name: name,
        error: SignInError.unavailable,
      ),
    });
  }
}
