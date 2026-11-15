import 'package:catalog/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/ui.dart';
import 'package:web_checkout/main.dart' as app;

const badLink = '/?bags=bag_unknown,bag_cafe,bag_cafe,bag_bakery,bag_grocery';

void main() {
  patrolTest('customer picks bags and a bad link is cleaned', ($) async {
    await (await SharedPreferences.getInstance()).clear();
    await app.main();
    await $.pumpAndSettle();

    await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
    for (final id in [
      'bag_grocery',
      'bag_cafe',
      'bag_bakery',
      'bag_surprise',
    ]) {
      expect($(CatalogKeys.bag(id)), findsOneWidget);
    }
    expect(summary($, CatalogKeys.summaryCount), 'No bags picked');

    await pick($, 'bag_cafe');
    await pick($, 'bag_bakery');
    expect(tile($, 'bag_cafe').selected, isTrue);
    expect(tile($, 'bag_bakery').selected, isTrue);
    expect(summary($, CatalogKeys.summaryCount), '2 bags');
    expect(summary($, CatalogKeys.summaryTotal), 'R109,98');
    if (kIsWeb) {
      expect(await currentLocation($), '/?bags=bag_cafe,bag_bakery');
    }

    await $(CatalogKeys.bag('bag_grocery')).scrollTo();
    expect(tile($, 'bag_grocery').enabled, isFalse);
    expect(
      $(CatalogKeys.bag('bag_grocery')).$('You can pick up to 2 bags'),
      findsOneWidget,
    );

    await pick($, 'bag_bakery');
    expect(tile($, 'bag_grocery').enabled, isTrue);
    expect($('You can pick up to 2 bags'), findsNothing);
    expect(summary($, CatalogKeys.summaryCount), '1 bag');
    if (kIsWeb) expect(await currentLocation($), '/?bags=bag_cafe');

    GoRouter.of($.tester.element(find.byType(CatalogPage))).go(badLink);
    await $.pumpAndSettle();
    await $.tester.ensureVisible(find.byKey(CatalogKeys.notice));
    await $.pumpAndSettle();
    await $('Some bags from the link were left out.').waitUntilVisible();
    expect(tile($, 'bag_cafe').selected, isTrue);
    expect(tile($, 'bag_bakery').selected, isTrue);
    expect(tile($, 'bag_grocery').selected, isFalse);
    expect(tile($, 'bag_surprise').selected, isFalse);
    expect(summary($, CatalogKeys.summaryCount), '2 bags');
    if (!kIsWeb) return;
    expect(await currentLocation($), '/?bags=bag_cafe,bag_bakery');

    // Picks and the clean-up replace entries, so Back skips the bad link.
    await $.platform.web.goBack();
    await $.pumpAndSettle();
    expect(await currentLocation($), '/?bags=bag_cafe');
    expect(tile($, 'bag_cafe').selected, isTrue);
    expect(tile($, 'bag_bakery').selected, isFalse);
  });
}

Future<void> pick(PatrolIntegrationTester $, String id) =>
    $(CatalogKeys.bag(id)).scrollTo().tap();

BagTile tile(PatrolIntegrationTester $, String id) =>
    $.tester.widget<BagTile>(find.byKey(CatalogKeys.bag(id)));

String? summary(PatrolIntegrationTester $, Key key) =>
    $.tester.widget<Text>(find.byKey(key)).data;

Future<String> currentLocation(PatrolIntegrationTester $) async {
  final url = Uri.parse(await $.platform.web.getCurrentPageUrl());
  return Uri.decodeFull(url.hasQuery ? '${url.path}?${url.query}' : url.path);
}
