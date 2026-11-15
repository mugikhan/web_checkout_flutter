import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

/// pumpPage pumps [page] in our theme with a plain text theme.
Future<void> pumpPage(WidgetTester tester, Widget page) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(textTheme: ThemeData().textTheme),
      home: page,
    ),
  );
  await tester.pump();
}
