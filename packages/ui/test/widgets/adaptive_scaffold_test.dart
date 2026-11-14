import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

const bagsKey = Key('bags');
const accountKey = Key('account');

Future<List<int>> pumpScaffold(WidgetTester tester, double width) async {
  final selections = <int>[];
  await pumpThemed(
    tester,
    AdaptiveScaffold(
      title: 'Bag Checkout',
      selectedIndex: 0,
      onDestinationSelected: selections.add,
      destinations: const [
        AdaptiveDestination(
          key: bagsKey,
          icon: Icons.shopping_bag_outlined,
          selectedIcon: Icons.shopping_bag,
          label: 'Bags',
        ),
        AdaptiveDestination(
          key: accountKey,
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Account',
        ),
      ],
      body: const Text('Body'),
    ),
    size: Size(width, 800),
    wrapInScaffold: false,
  );
  return selections;
}

void main() {
  testWidgets('599px shows a bottom bar and the title in an app bar', (
    tester,
  ) async {
    await pumpScaffold(tester, 599);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Bag Checkout'),
      ),
      findsOneWidget,
    );
  });

  for (final width in [600.0, 839.0]) {
    testWidgets('${width}px shows a rail with icons only', (tester) async {
      await pumpScaffold(tester, width);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(find.byType(NavigationBar), findsNothing);
    });
  }

  testWidgets('840px shows an extended rail with labels and the title', (
    tester,
  ) async {
    await pumpScaffold(tester, 840);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
    expect(find.text('Bag Checkout'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  for (final width in [599.0, 700.0, 840.0]) {
    testWidgets('${width}px exposes labels and selects by key', (tester) async {
      final semantics = tester.ensureSemantics();
      final selections = await pumpScaffold(tester, width);

      expect(find.bySemanticsLabel(RegExp('Bags')), findsWidgets);
      expect(find.bySemanticsLabel(RegExp('Account')), findsWidgets);

      await tester.tap(find.byKey(accountKey));
      expect(selections, [1]);
      semantics.dispose();
    });
  }
}
