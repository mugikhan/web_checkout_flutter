import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import 'test_text_theme.dart';

/// pumpThemed pumps [child] in an app with our theme at a fixed window size.
Future<void> pumpThemed(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  Size size = const Size(400, 800),
  bool wrapInScaffold = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light
          ? AppTheme.light(textTheme: testTextTheme)
          : AppTheme.dark(textTheme: testTextTheme),
      home: wrapInScaffold ? Scaffold(body: Center(child: child)) : child,
    ),
  );
}
