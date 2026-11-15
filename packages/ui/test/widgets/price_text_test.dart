import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: shows the price and a crossed-out worth', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const PriceText(priceCents: 5999, worthCents: 18000),
        brightness: brightness,
      );

      final price = tester.widget<Text>(find.text('R59,99'));
      final worth = tester.widget<Text>(find.text('R180,00'));
      expect(price.style?.color, colors.onSurface);
      expect(worth.style?.decoration, TextDecoration.lineThrough);
      expect(worth.style?.color, colors.onSurfaceVariant);
    });
  }

  testWidgets('without a worth shows only the price', (tester) async {
    await pumpThemed(tester, const PriceText(priceCents: 4999));

    expect(find.text('R49,99'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('announces the price, then the worth', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(
      tester,
      const PriceText(priceCents: 5999, worthCents: 18000),
    );

    expect(find.bySemanticsLabel('R59,99, worth R180,00'), findsOneWidget);
    semantics.dispose();
  });
}
