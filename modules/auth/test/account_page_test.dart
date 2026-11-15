import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/mocks.dart';
import 'support/pump_page.dart';

void main() {
  testWidgets('shows the viewer name and signs out', (tester) async {
    final repository = MockAuthRepository();
    when(() => repository.currentViewer()).thenAnswer((_) async => naledi);
    when(() => repository.signOut()).thenAnswer((_) async {});
    var signOuts = 0;
    // BlocProvider owns the bloc, so it closes inside the test zone.
    await pumpPage(
      tester,
      BlocProvider(
        create: (_) =>
            SessionBloc(authRepository: repository)
              ..add(const SessionCheckRequested()),
        child: AccountPage(onSignOut: () => signOuts++),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Naledi'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);

    await tester.tap(find.byKey(AuthKeys.signOut));
    await tester.pumpAndSettle();

    final session = tester
        .element(find.byType(AccountPage))
        .read<SessionBloc>();
    expect(signOuts, 1);
    verify(() => repository.signOut()).called(1);
    expect(session.state, const SessionSignedOut());
  });
}
