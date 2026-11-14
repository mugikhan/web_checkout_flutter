import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:web_checkout/app.dart';

/// pumpApp starts the app at [location] with a plain text theme.
Future<void> pumpApp(
  WidgetTester tester, {
  String location = '/',
  Size size = const Size(400, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    BagCheckoutApp(initialLocation: location, textTheme: ThemeData().textTheme),
  );
  await tester.pumpAndSettle();
}

/// currentLocation reads the router's current URI path.
String currentLocation(WidgetTester tester) {
  final context = tester.element(find.byType(Navigator).first);
  return GoRouter.of(context).routerDelegate.currentConfiguration.uri
      .toString();
}
