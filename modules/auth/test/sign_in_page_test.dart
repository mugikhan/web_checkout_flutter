import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';
import 'support/pump_page.dart';

// The button keeps its spinner after success, so pumpAndSettle never ends.
Future<void> pumpBlocs(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  late MockAuthRepository repository;
  late SessionBloc session;
  late int backs;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.signIn(any()))
        .thenAnswer((_) async => const SignedIn(naledi));
    session = SessionBloc(authRepository: repository);
    backs = 0;
  });

  tearDown(() => session.close());

  Future<void> pump(WidgetTester tester) => pumpPage(
    tester,
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: session),
        BlocProvider(create: (_) => SignInBloc(authRepository: repository)),
      ],
      child: SignInPage(onBack: () => backs++),
    ),
  );

  testWidgets('a short name shows the inline error and stays signed out', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Bob');
    await tester.tap(find.byKey(AuthKeys.signInSubmit));
    await tester.pumpAndSettle();

    expect(find.text('Enter at least 4 characters'), findsOneWidget);
    verifyNever(() => repository.signIn(any()));
    expect(session.state, const SessionChecking());

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Bobby');
    await tester.pump();
    expect(find.text('Enter at least 4 characters'), findsNothing);
  });

  testWidgets('a valid name signs the session in', (tester) async {
    await pump(tester);

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
    await tester.tap(find.byKey(AuthKeys.signInSubmit));
    await pumpBlocs(tester);

    verify(() => repository.signIn('Naledi')).called(1);
    expect(session.state, const SessionSignedIn(naledi));
  });

  testWidgets('the keyboard done action submits', (tester) async {
    await pump(tester);

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await pumpBlocs(tester);

    verify(() => repository.signIn('Naledi')).called(1);
  });

  testWidgets('an unexpected failure shows the retry message', (tester) async {
    when(() => repository.signIn(any()))
        .thenAnswer((_) async => const SignInUnavailable());
    await pump(tester);

    await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
    await tester.tap(find.byKey(AuthKeys.signInSubmit));
    await tester.pumpAndSettle();

    expect(find.text('Sign-in failed. Try again.'), findsOneWidget);
  });

  testWidgets('the back action calls onBack', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(AuthKeys.signInBack));

    expect(backs, 1);
  });

  testWidgets('the field, the submit and the back action have labels', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);

    expect(find.bySemanticsLabel('Name'), findsOneWidget);
    expect(find.bySemanticsLabel('Sign in'), findsWidgets);
    expect(find.byTooltip('Back to Bags'), findsOneWidget);
    semantics.dispose();
  });
}
