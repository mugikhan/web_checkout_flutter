import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  testWidgets('shows its message and fires dismiss', (tester) async {
    var dismissed = 0;
    await pumpThemed(
      tester,
      InlineNotice(
        message: 'Some bags were left out.',
        dismissKey: const Key('dismiss'),
        onDismiss: () => dismissed++,
      ),
    );

    expect(find.text('Some bags were left out.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('dismiss')));
    expect(dismissed, 1);
  });

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: uses the secondary colour pair', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        InlineNotice(message: 'Note', onDismiss: () {}),
        brightness: brightness,
      );

      final surface = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(InlineNotice),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(surface.color, colors.secondary);
      expect(
        tester.widget<Text>(find.text('Note')).style?.color,
        colors.onSecondary,
      );
    });
  }

  testWidgets('is a live region with a labelled dismiss action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(tester, InlineNotice(message: 'Note', onDismiss: () {}));

    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.liveRegion ?? false),
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Dismiss'), findsOneWidget);
    semantics.dispose();
  });
}
