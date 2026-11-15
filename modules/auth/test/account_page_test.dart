import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_auth_repository.dart';
import 'support/pump_page.dart';

void main() {
  testWidgets('shows the viewer name and signs out', (tester) async {
    final repository = FakeAuthRepository(viewer: FakeAuthRepository.naledi);
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
    expect(repository.signOutCalls, 1);
    expect(session.state, const SessionSignedOut());
  });
}
