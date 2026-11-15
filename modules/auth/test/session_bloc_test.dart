import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() => repository = MockAuthRepository());

  SessionBloc build() => SessionBloc(authRepository: repository);

  test('starts in SessionChecking', () {
    expect(build().state, const SessionChecking());
  });

  blocTest<SessionBloc, SessionState>(
    'restores a stored viewer',
    setUp: () =>
        when(() => repository.currentViewer()).thenAnswer((_) async => naledi),
    build: build,
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedIn(naledi)],
  );

  blocTest<SessionBloc, SessionState>(
    'reads no viewer as signed out',
    setUp: () =>
        when(() => repository.currentViewer()).thenAnswer((_) async => null),
    build: build,
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedOut()],
  );

  blocTest<SessionBloc, SessionState>(
    'reads an ApiFault as signed out',
    setUp: () =>
        when(() => repository.currentViewer())
            .thenThrow(const ApiFault('boom')),
    build: build,
    act: (bloc) => bloc.add(const SessionCheckRequested()),
    expect: () => [const SessionSignedOut()],
  );

  blocTest<SessionBloc, SessionState>(
    'moves to signed in on ViewerSignedIn',
    build: build,
    seed: () => const SessionSignedOut(),
    act: (bloc) => bloc.add(const ViewerSignedIn(naledi)),
    expect: () => [const SessionSignedIn(naledi)],
    verify: (_) => verifyZeroInteractions(repository),
  );

  blocTest<SessionBloc, SessionState>(
    'signs out through the repository',
    setUp: () => when(() => repository.signOut()).thenAnswer((_) async {}),
    build: build,
    seed: () => const SessionSignedIn(naledi),
    act: (bloc) => bloc.add(const SignOutRequested()),
    expect: () => [const SessionSignedOut()],
    verify: (_) => verify(() => repository.signOut()).called(1),
  );
}
