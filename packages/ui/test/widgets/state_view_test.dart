import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  testWidgets('empty shows its title, message and action', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      StateView.empty(
        title: 'No bags yet',
        message: 'Check back soon.',
        actionLabel: 'Refresh',
        onAction: () => taps++,
      ),
    );
    expect(find.text('No bags yet'), findsOneWidget);
    expect(find.text('Check back soon.'), findsOneWidget);

    await tester.tap(find.text('Refresh'));
    expect(taps, 1);
  });

  testWidgets('empty without an action shows no button', (tester) async {
    await pumpThemed(tester, const StateView.empty(title: 'Nothing here'));
    expect(find.byType(AppButton), findsNothing);
  });

  testWidgets('error colours its icon and fires its action', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      StateView.error(
        title: 'Something went wrong',
        actionLabel: 'Try again',
        onAction: () => taps++,
      ),
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
    expect(icon.color, AppColors.light.error);

    await tester.tap(find.text('Try again'));
    expect(taps, 1);
  });

  testWidgets('loading shows a spinner and its title', (tester) async {
    await pumpThemed(tester, const StateView.loading(title: 'Loading bags'));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading bags'), findsOneWidget);
  });
}
