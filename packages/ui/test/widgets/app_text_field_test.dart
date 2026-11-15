import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../support/pump_themed.dart';

void main() {
  testWidgets('shows the label and reports changes and submits', (
    tester,
  ) async {
    final changes = <String>[];
    String? submitted;
    await pumpThemed(
      tester,
      AppTextField(
        label: 'Name',
        onChanged: changes.add,
        onSubmitted: (value) => submitted = value,
      ),
    );

    expect(find.text('Name'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Naledi');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    expect(changes.last, 'Naledi');
    expect(submitted, 'Naledi');
  });

  for (final (brightness, colors) in [
    (Brightness.light, AppColors.light),
    (Brightness.dark, AppColors.dark),
  ]) {
    testWidgets('${brightness.name}: shows the error in the error colour', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const AppTextField(label: 'Name', errorText: 'Too short'),
        brightness: brightness,
      );

      final error = tester.widget<Text>(find.text('Too short'));
      final context = tester.element(find.text('Too short'));
      final style = DefaultTextStyle.of(context).style.merge(error.style);
      expect(style.color, colors.error);

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      final theme = Theme.of(context).inputDecorationTheme;
      expect(decorator.decoration.errorText, 'Too short');
      expect(theme.errorBorder!.borderSide.color, colors.error);
    });
  }

  testWidgets('announces its label and error', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpThemed(
      tester,
      const AppTextField(label: 'Name', errorText: 'Too short'),
    );

    final node = tester.getSemantics(find.byType(EditableText));
    expect(node.label, 'Name');
    expect(node.hint, 'Too short');
    semantics.dispose();
  });
}
