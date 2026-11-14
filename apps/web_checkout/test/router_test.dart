import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
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

  testWidgets('/account shows Account with Account selected', (tester) async {
    await pumpApp(tester, location: '/account');

    expect(find.text('Account'), findsWidgets);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 1);
  });

  testWidgets('selecting a destination updates the URL', (tester) async {
    await pumpApp(tester);

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
    await pumpApp(tester, location: '/account');
    expect(find.byType(NavigationBar), findsOneWidget);

    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(currentLocation(tester), '/account');
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 1);
  });
}
