import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_auth_repository.dart';

void main() {
  const naledi = FakeAuthRepository.naledi;
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  SignInBloc build() => SignInBloc(authRepository: repository);

  blocTest<SignInBloc, SignInState>(
    'a name of 3 characters shows the error and sends nothing',
    build: build,
    act: (bloc) => bloc
      ..add(const SignInNameChanged('Bob'))
      ..add(const SignInSubmitted()),
    expect: () => [
      const SignInState(name: 'Bob'),
      const SignInState(name: 'Bob', error: SignInError.nameTooShort),
    ],
    verify: (_) => expect(repository.signInCalls, isEmpty),
  );

  blocTest<SignInBloc, SignInState>(
    'only spaces show the error and send nothing',
    build: build,
    act: (bloc) => bloc
      ..add(const SignInNameChanged('     '))
      ..add(const SignInSubmitted()),
    skip: 1,
    expect: () => [
      const SignInState(name: '     ', error: SignInError.nameTooShort),
    ],
    verify: (_) => expect(repository.signInCalls, isEmpty),
  );

  blocTest<SignInBloc, SignInState>(
    'a valid name signs in with the trimmed name',
    build: build,
    act: (bloc) => bloc
      ..add(const SignInNameChanged('  Naledi '))
      ..add(const SignInSubmitted()),
    skip: 1,
    expect: () => [
      const SignInState(name: '  Naledi ', status: SignInStatus.submitting),
      const SignInState(
        name: '  Naledi ',
        status: SignInStatus.succeeded,
        viewer: naledi,
      ),
    ],
    verify: (_) => expect(repository.signInCalls, ['Naledi']),
  );

  blocTest<SignInBloc, SignInState>(
    'a "server" InvalidName shows the error with its minimum length',
    build: () {
      repository.signInResult = const InvalidName(minLength: 5);
      return build();
    },
    act: (bloc) => bloc
      ..add(const SignInNameChanged('Thab'))
      ..add(const SignInSubmitted()),
    skip: 2,
    expect: () => [
      const SignInState(
        name: 'Thab',
        error: SignInError.nameTooShort,
        minLength: 5,
      ),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'SignInUnavailable shows the retry error and allows a new submit',
    build: () {
      repository.signInResult = const SignInUnavailable();
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const SignInNameChanged('Naledi'))
        ..add(const SignInSubmitted());
      await Future<void>.delayed(Duration.zero);
      repository.signInResult = const SignedIn(naledi);
      bloc.add(const SignInSubmitted());
    },
    skip: 2,
    expect: () => [
      const SignInState(name: 'Naledi', error: SignInError.unavailable),
      const SignInState(name: 'Naledi', status: SignInStatus.submitting),
      const SignInState(
        name: 'Naledi',
        status: SignInStatus.succeeded,
        viewer: naledi,
      ),
    ],
    verify: (_) => expect(repository.signInCalls, hasLength(2)),
  );

  blocTest<SignInBloc, SignInState>(
    'editing the name clears the error',
    build: build,
    seed: () => const SignInState(name: 'Bob', error: SignInError.nameTooShort),
    act: (bloc) => bloc.add(const SignInNameChanged('Bobb')),
    expect: () => [const SignInState(name: 'Bobb')],
  );

  blocTest<SignInBloc, SignInState>(
    'a second submit while one runs is dropped',
    build: () {
      repository.signInGate = Completer<void>();
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const SignInNameChanged('Naledi'))
        ..add(const SignInSubmitted())
        ..add(const SignInSubmitted());
      await Future<void>.delayed(Duration.zero);
      repository.signInGate!.complete();
    },
    skip: 1,
    expect: () => [
      const SignInState(name: 'Naledi', status: SignInStatus.submitting),
      const SignInState(
        name: 'Naledi',
        status: SignInStatus.succeeded,
        viewer: naledi,
      ),
    ],
    verify: (_) => expect(repository.signInCalls, ['Naledi']),
  );
}
