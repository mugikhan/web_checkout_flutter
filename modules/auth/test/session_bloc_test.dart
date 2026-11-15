import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_auth_repository.dart';

void main() {
  const naledi = FakeAuthRepository.naledi;

  test('starts in SessionChecking', () {
    expect(
      SessionBloc(authRepository: FakeAuthRepository()).state,
      const SessionChecking(),
    );
  });

  blocTest<SessionBloc, SessionState>(
    'restores a stored viewer',
    build: () =>
        SessionBloc(authRepository: FakeAuthRepository(viewer: naledi)),
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedIn(naledi)],
  );

  blocTest<SessionBloc, SessionState>(
    'reads no viewer as signed out',
    build: () => SessionBloc(authRepository: FakeAuthRepository()),
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedOut()],
  );

  blocTest<SessionBloc, SessionState>(
    'reads an ApiFault as signed out',
    build: () => SessionBloc(
      authRepository: FakeAuthRepository(currentViewerFault: true),
    ),
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedOut()],
  );

  blocTest<SessionBloc, SessionState>(
    'moves to signed in on ViewerSignedIn',
    build: () => SessionBloc(authRepository: FakeAuthRepository()),
    seed: () => const SessionSignedOut(),
    act: (bloc) => bloc.add(const ViewerSignedIn(naledi)),
    expect: () => [const SessionSignedIn(naledi)],
  );

  final repository = FakeAuthRepository(viewer: naledi);
  blocTest<SessionBloc, SessionState>(
    'signs out through the repository',
    build: () => SessionBloc(authRepository: repository),
    seed: () => const SessionSignedIn(naledi),
    act: (bloc) => bloc.add(const SignOutRequested()),
    expect: () => [const SessionSignedOut()],
    verify: (_) {
      expect(repository.signOutCalls, 1);
      expect(repository.viewer, isNull);
    },
  );
}
