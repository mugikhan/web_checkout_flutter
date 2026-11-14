import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

Color? backgroundOf(WidgetTester tester) => tester
    .widget<Material>(
      find.descendant(
        of: find.byType(TextButton),
        matching: find.byType(Material),
      ),
    )
    .color;

Color? labelColorOf(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(find.text(label)).text.style?.color;

void main() {
  group('primary colours', () {
    testWidgets('light: forest with a lime label', (tester) async {
      await pumpThemed(tester, AppButton(label: 'Pay', onPressed: () {}));
      expect(backgroundOf(tester), AppColors.light.primary);
      expect(labelColorOf(tester, 'Pay'), AppColors.light.onPrimary);
    });

    testWidgets('dark: lime with a forest label', (tester) async {
      await pumpThemed(
        tester,
        AppButton(label: 'Pay', onPressed: () {}),
        brightness: Brightness.dark,
      );
      expect(backgroundOf(tester), AppColors.dark.primary);
      expect(labelColorOf(tester, 'Pay'), AppColors.dark.onPrimary);
    });
  });

  for (final variant in [AppButtonVariant.secondary, AppButtonVariant.ghost]) {
    for (final (brightness, colors) in [
      (Brightness.light, AppColors.light),
      (Brightness.dark, AppColors.dark),
    ]) {
      testWidgets(
        '${variant.name} ${brightness.name}: clear with onSurface text',
        (tester) async {
          await pumpThemed(
            tester,
            AppButton(label: 'Back', onPressed: () {}, variant: variant),
            brightness: brightness,
          );
          expect(backgroundOf(tester), Colors.transparent);
          expect(labelColorOf(tester, 'Back'), colors.onSurface);
        },
      );
    }
  }

  testWidgets('a tap calls onPressed', (tester) async {
    var taps = 0;
    await pumpThemed(tester, AppButton(label: 'Pay', onPressed: () => taps++));
    await tester.tap(find.byType(AppButton));
    expect(taps, 1);
  });

  testWidgets('while loading it ignores taps, keeps its colour and says so', (
    tester,
  ) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    await pumpThemed(
      tester,
      AppButton(label: 'Pay', onPressed: () => taps++, loading: true),
    );

    await tester.tap(find.byType(AppButton));
    expect(taps, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(backgroundOf(tester), AppColors.light.primary);
    expect(find.bySemanticsLabel('Pay, loading'), findsOneWidget);
    semantics.dispose();
  });
}
