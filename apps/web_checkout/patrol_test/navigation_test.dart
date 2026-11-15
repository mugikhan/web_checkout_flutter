import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_checkout/app_keys.dart';
import 'package:web_checkout/main.dart' as app;

void main() {
  patrolTest('user moves between Bags and Account', ($) async {
    await (await SharedPreferences.getInstance()).clear();
    await app.main();
    await $.pumpAndSettle();

    expect($('Bag Checkout'), findsWidgets);
    await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();

    await $(AppKeys.navAccount).tap();
    expect($(AuthKeys.signInName), findsOneWidget);
    if (kIsWeb) {
      expect(urlStrategy, isA<PathUrlStrategy>());
      expect(await currentLocation($), '/sign-in?from=/account');
    }

    await $(AuthKeys.signInBack).tap();
    await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
    if (kIsWeb) expect(await currentPath($), '/');

    if (!kIsWeb) return;

    await $.platform.web.resizeWindow(size: const Size(500, 900));
    await $.pumpAndSettle();
    expect($(NavigationBar), findsOneWidget);

    await $.platform.web.resizeWindow(size: const Size(700, 900));
    await $.pumpAndSettle();
    expect(rail($).extended, isFalse);

    await $.platform.web.resizeWindow(size: const Size(1200, 900));
    await $.pumpAndSettle();
    expect(rail($).extended, isTrue);
    expect(await currentPath($), '/');

    await $.platform.web.enableDarkMode();
    await $.pumpAndSettle();
    expect(brightness($), Brightness.dark);

    await $.platform.web.disableDarkMode();
    await $.pumpAndSettle();
    expect(brightness($), Brightness.light);
  });
}

Future<String> currentPath(PatrolIntegrationTester $) async =>
    Uri.parse(await $.platform.web.getCurrentPageUrl()).path;

Future<String> currentLocation(PatrolIntegrationTester $) async {
  final url = Uri.parse(await $.platform.web.getCurrentPageUrl());
  return Uri.decodeFull(url.hasQuery ? '${url.path}?${url.query}' : url.path);
}

NavigationRail rail(PatrolIntegrationTester $) =>
    $.tester.widget<NavigationRail>(find.byType(NavigationRail));

Brightness brightness(PatrolIntegrationTester $) =>
    Theme.of($.tester.element(find.byType(NavigationRail))).brightness;
