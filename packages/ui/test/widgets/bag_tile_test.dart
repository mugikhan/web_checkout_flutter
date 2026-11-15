import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  Widget tile({
    bool selected = false,
    bool enabled = true,
    String? hint,
    VoidCallback? onTap,
  }) => SizedBox(
    width: 360,
    child: BagTile(
      key: const Key('tile'),
      title: 'Café bag',
      description: 'Sandwiches and a drink.',
      priceCents: 5999,
      worthCents: 18000,
      selected: selected,
      enabled: enabled,
      hint: hint,
      onTap: onTap ?? () {},
    ),
  );

  ShapeBorder shape(WidgetTester tester) => tester
      .widget<Material>(
        find.descendant(
          of: find.byKey(const Key('tile')),
          matching: find.byType(Material),
        ),
      )
      .shape!;

  testWidgets('shows the name, description and price, and reports taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpThemed(tester, tile(onTap: () => taps++));

    expect(find.text('Café bag'), findsOneWidget);
    expect(find.text('Sandwiches and a drink.'), findsOneWidget);
    expect(find.text('R59,99'), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

    await tester.tap(find.byKey(const Key('tile')));
    expect(taps, 1);
  });

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: a picked tile has a primary border', (
      tester,
    ) async {
      await pumpThemed(tester, tile(selected: true), brightness: brightness);

      final border = (shape(tester) as RoundedRectangleBorder).side;
      expect(border.color, colors.primary);
      expect(border.width, 2);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  }

  testWidgets('a disabled tile ignores taps and shows its hint', (
    tester,
  ) async {
    var taps = 0;
    await pumpThemed(
      tester,
      tile(
        enabled: false,
        hint: 'You can pick up to 2 bags',
        onTap: () => taps++,
      ),
    );

    await tester.tap(find.byKey(const Key('tile')));
    expect(taps, 0);
    final hint = tester.widget<Text>(find.text('You can pick up to 2 bags'));
    expect(hint.style?.color, AppColors.light.onSurfaceVariant);
  });

  testWidgets('announces name, price, checked state and hint', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(tester, tile(selected: true));

    expect(
      tester.getSemantics(find.byKey(const Key('tile'))),
      isSemantics(
        label: 'Café bag, R59,99, worth R180,00',
        isButton: true,
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    await pumpThemed(
      tester,
      tile(enabled: false, hint: 'You can pick up to 2 bags'),
    );
    expect(
      tester.getSemantics(find.byKey(const Key('tile'))),
      isSemantics(
        hint: 'You can pick up to 2 bags',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
    semantics.dispose();
  });
}
