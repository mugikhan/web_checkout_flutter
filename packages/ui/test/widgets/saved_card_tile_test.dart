import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  Widget tile({
    bool selected = false,
    bool busy = false,
    VoidCallback? onTap,
  }) => SizedBox(
    width: 360,
    child: SavedCardTile(
      key: const Key('card'),
      label: 'Visa •••• 4242',
      semanticLabel: 'Visa ending in 4242',
      selected: selected,
      busy: busy,
      onTap: onTap ?? () {},
    ),
  );

  BorderSide side(WidgetTester tester) =>
      (tester
                  .widget<Material>(
                    find.descendant(
                      of: find.byKey(const Key('card')),
                      matching: find.byType(Material),
                    ),
                  )
                  .shape!
              as RoundedRectangleBorder)
          .side;

  testWidgets('shows the masked number and reports taps', (tester) async {
    var taps = 0;
    await pumpThemed(tester, tile(onTap: () => taps++));

    await tester.tap(find.byKey(const Key('card')));

    expect(taps, 1);
    expect(find.text('Visa •••• 4242'), findsOneWidget);
    expect(find.byIcon(Icons.credit_card), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
  });

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: picked has a primary border and check', (
      tester,
    ) async {
      await pumpThemed(tester, tile(selected: true), brightness: brightness);

      expect(side(tester).color, colors.primary);
      expect(side(tester).width, 2);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  }

  testWidgets('busy shows a progress indicator in place of the check', (
    tester,
  ) async {
    await pumpThemed(tester, tile(selected: true, busy: true));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('announces the card without bullets', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(tester, tile(selected: true));

    expect(
      tester.getSemantics(find.byKey(const Key('card'))),
      isSemantics(
        label: 'Visa ending in 4242',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });
}
