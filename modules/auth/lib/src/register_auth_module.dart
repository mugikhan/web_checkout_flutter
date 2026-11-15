import 'package:get_it/get_it.dart';

import 'session/session_bloc.dart';
import 'sign_in/sign_in_bloc.dart';

/// registerAuthModule registers the auth blocs; the app registers AuthRepository first.
void registerAuthModule(GetIt sl) {
  sl
    ..registerFactory(() => SessionBloc(authRepository: sl()))
    ..registerFactory(() => SignInBloc(authRepository: sl()));
}
