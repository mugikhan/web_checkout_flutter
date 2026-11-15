import 'package:flutter_test/flutter_test.dart';
import 'package:auth/auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_checkout/app_keys.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('/ shows Bags with Bags selected', (tester) async {
    await pumpApp(tester);

    expect(
      find.text('Surplus bags from Corner Pantry will show here.'),
      findsOneWidget,
    );
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 0);
  });

  testWidgets('/account shows Account to a signed-in viewer', (tester) async {
    await pumpApp(
      tester,
      location: '/account',
      repository: mockAuthRepository(viewer: naledi),
    );

    expect(find.text('Naledi'), findsOneWidget);
    expect(currentLocation(tester), '/account');
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 1);
  });

  testWidgets('selecting a destination updates the URL', (tester) async {
    await pumpApp(tester, repository: mockAuthRepository(viewer: naledi));

    await tester.tap(find.byKey(AppKeys.navAccount));
    await tester.pumpAndSettle();
    expect(currentLocation(tester), '/account');

    await tester.tap(find.byKey(AppKeys.navBags));
    await tester.pumpAndSettle();
    expect(currentLocation(tester), '/');
  });

  testWidgets('an unknown URL shows Page not found without navigation', (
    tester,
  ) async {
    await pumpApp(tester, location: '/does-not-exist');

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(currentLocation(tester), '/does-not-exist');
  });

  testWidgets('Go to Bags leaves the not-found view for /', (tester) async {
    await pumpApp(tester, location: '/does-not-exist');

    await tester.tap(find.byKey(AppKeys.notFoundGoToBags));
    await tester.pumpAndSettle();

    expect(currentLocation(tester), '/');
    expect(
      find.text('Surplus bags from Corner Pantry will show here.'),
      findsOneWidget,
    );
  });

  testWidgets('resizing across a breakpoint keeps the page and URL', (
    tester,
  ) async {
    await pumpApp(
      tester,
      location: '/account',
      repository: mockAuthRepository(viewer: naledi),
    );
    expect(find.byType(NavigationBar), findsOneWidget);

    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(currentLocation(tester), '/account');
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 1);
  });

  group('guard', () {
    testWidgets('a signed-out user on /account lands on sign-in', (
      tester,
    ) async {
      await pumpApp(tester, location: '/account');

      expect(find.byKey(AuthKeys.signInName), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(currentLocation(tester), '/sign-in?from=%2Faccount');
    });

    testWidgets('selecting Account signed out opens sign-in', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byKey(AppKeys.navAccount));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/sign-in?from=%2Faccount');
    });

    testWidgets('a short name stays on sign-in with the error', (tester) async {
      final repository = mockAuthRepository();
      await pumpApp(tester, location: '/account', repository: repository);

      await tester.enterText(find.byKey(AuthKeys.signInName), 'Bob');
      await tester.tap(find.byKey(AuthKeys.signInSubmit));
      await tester.pumpAndSettle();

      expect(find.text('Enter at least 4 characters'), findsOneWidget);
      expect(currentLocation(tester), '/sign-in?from=%2Faccount');
      verifyNever(() => repository.signIn(any()));
    });

    testWidgets('signing in returns to from', (tester) async {
      await pumpApp(tester, location: '/account');

      await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
      await tester.tap(find.byKey(AuthKeys.signInSubmit));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/account');
      expect(find.text('Naledi'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('signing in without from goes to Bags', (tester) async {
      await pumpApp(tester, location: '/sign-in');

      await tester.enterText(find.byKey(AuthKeys.signInName), 'Naledi');
      await tester.tap(find.byKey(AuthKeys.signInSubmit));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/');
    });

    testWidgets('a signed-in viewer on sign-in goes to from', (tester) async {
      await pumpApp(
        tester,
        location: '/sign-in?from=%2Faccount',
        repository: mockAuthRepository(viewer: naledi),
      );

      expect(currentLocation(tester), '/account');
    });

    testWidgets('the back action on sign-in returns to Bags', (tester) async {
      await pumpApp(tester, location: '/sign-in');

      await tester.tap(find.byKey(AuthKeys.signInBack));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/');
    });

    testWidgets('sign out returns to Bags and guards Account again', (
      tester,
    ) async {
      final repository = mockAuthRepository(viewer: naledi);
      await pumpApp(tester, location: '/account', repository: repository);

      await tester.tap(find.byKey(AuthKeys.signOut));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/');
      verify(() => repository.signOut()).called(1);

      await tester.tap(find.byKey(AppKeys.navAccount));
      await tester.pumpAndSettle();
      expect(currentLocation(tester), '/sign-in?from=%2Faccount');
    });
  });
}
