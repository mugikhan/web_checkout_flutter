import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  Widget chip({bool selected = false, VoidCallback? onTap}) => WindowChip(
    key: const Key('chip'),
    label: '14:00–15:00',
    semanticLabel: 'Today, 14:00 to 15:00',
    selected: selected,
    onTap: onTap ?? () {},
  );

  Material material(WidgetTester tester) => tester.widget<Material>(
    find.descendant(
      of: find.byKey(const Key('chip')),
      matching: find.byType(Material),
    ),
  );

  Color? textColor(WidgetTester tester) =>
      tester.widget<Text>(find.text('14:00–15:00')).style?.color;

  testWidgets('shows its label and reports taps', (tester) async {
    var taps = 0;
    await pumpThemed(tester, chip(onTap: () => taps++));

    await tester.tap(find.byKey(const Key('chip')));

    expect(taps, 1);
    expect(tester.getSize(find.byKey(const Key('chip'))).height, 48);
  });

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: picked uses primary and onPrimary', (
      tester,
    ) async {
      await pumpThemed(tester, chip(selected: true), brightness: brightness);

      expect(material(tester).color, colors.primary);
      expect(textColor(tester), colors.onPrimary);
    });

    testWidgets('${brightness.name}: not picked uses surfaceContainer', (
      tester,
    ) async {
      await pumpThemed(tester, chip(), brightness: brightness);

      expect(material(tester).color, colors.surfaceContainer);
      expect(textColor(tester), colors.onSurface);
      final side = (material(tester).shape! as RoundedRectangleBorder).side;
      expect(side.color, colors.outline);
    });
  }

  testWidgets('announces its label and selected state', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(tester, chip(selected: true));

    expect(
      tester.getSemantics(find.byKey(const Key('chip'))),
      isSemantics(
        label: 'Today, 14:00 to 15:00',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });
}
