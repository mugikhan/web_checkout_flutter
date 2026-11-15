import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() => repository = MockAuthRepository());

  SignInBloc build() => SignInBloc(authRepository: repository);

  void answerSignIn(SignInResult result) =>
      when(() => repository.signIn(any())).thenAnswer((_) async => result);

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
    verify: (_) => verifyNever(() => repository.signIn(any())),
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
    verify: (_) => verifyNever(() => repository.signIn(any())),
  );

  blocTest<SignInBloc, SignInState>(
    'a valid name signs in with the trimmed name',
    setUp: () => answerSignIn(const SignedIn(naledi)),
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
    verify: (_) => verify(() => repository.signIn('Naledi')).called(1),
  );

  blocTest<SignInBloc, SignInState>(
    'a "server" InvalidName shows the error with its minimum length',
    setUp: () => answerSignIn(const InvalidName(minLength: 5)),
    build: build,
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
    setUp: () => answerSignIn(const SignInUnavailable()),
    build: build,
    act: (bloc) async {
      bloc
        ..add(const SignInNameChanged('Naledi'))
        ..add(const SignInSubmitted());
      await Future<void>.delayed(Duration.zero);
      answerSignIn(const SignedIn(naledi));
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
    verify: (_) => verify(() => repository.signIn('Naledi')).called(2),
  );

  blocTest<SignInBloc, SignInState>(
    'editing the name clears the error',
    build: build,
    seed: () => const SignInState(name: 'Bob', error: SignInError.nameTooShort),
    act: (bloc) => bloc.add(const SignInNameChanged('Bobb')),
    expect: () => [const SignInState(name: 'Bobb')],
  );

  final gate = Completer<SignInResult>();
  blocTest<SignInBloc, SignInState>(
    'a second submit while one runs is dropped',
    setUp: () =>
        when(() => repository.signIn(any())).thenAnswer((_) => gate.future),
    build: build,
    act: (bloc) async {
      bloc
        ..add(const SignInNameChanged('Naledi'))
        ..add(const SignInSubmitted())
        ..add(const SignInSubmitted());
      await Future<void>.delayed(Duration.zero);
      gate.complete(const SignedIn(naledi));
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
    verify: (_) => verify(() => repository.signIn('Naledi')).called(1),
  );
}
