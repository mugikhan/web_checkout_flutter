import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'support/mocks.dart';

void main() {
  test('registers a fresh bloc per lookup', () {
    final sl = GetIt.asNewInstance()
      ..registerSingleton<AuthRepository>(MockAuthRepository());

    registerAuthModule(sl);

    expect(sl<SessionBloc>(), isNot(same(sl<SessionBloc>())));
    expect(sl<SignInBloc>(), isA<SignInBloc>());
  });
}
