import 'dart:convert';

import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/orders.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/ui.dart';
import 'package:web_checkout/app_keys.dart';
import 'package:web_checkout/main.dart' as app;

const bags = 'bag_cafe,bag_bakery';
const slotNotice =
    'That time slot is no longer available, please select another time slot '
    'and confirm your order';

void main() {
  patrolTest(
    'customer checks out once, and unknown sessions and stale slots show errors',
    ($) async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      await app.main();
      await $.pumpAndSettle();

      await pick($, 'bag_cafe');
      await pick($, 'bag_bakery');
      await $(CatalogKeys.continueButton).tap();

      await $(AuthKeys.signInName).waitUntilVisible();
      if (kIsWeb) {
        expect(
          await currentLocation($),
          '/sign-in?from=/checkout/new?bags=$bags',
        );
      }
      await enterName($, 'Naledi');
      await $(AuthKeys.signInSubmit).tap();

      await $(CheckoutKeys.confirm).waitUntilVisible();
      expect($('Café bag'), findsWidgets);
      expect($('Bakery bag'), findsWidgets);
      expect(total($), 'R109,98');
      String? sessionId;
      if (kIsWeb) {
        final match = RegExp(
          r'^/checkout/(cs_[0-9a-f]{16})\?bags=bag_cafe,bag_bakery$',
        ).firstMatch(await currentLocation($));
        expect(match, isNotNull);
        sessionId = match!.group(1);
      }
      expect(confirmEnabled($), isFalse);

      final slot = firstSlot($);
      await $(CheckoutKeys.window(slot)).scrollTo().tap();
      expect(
        $.tester
            .widget<WindowChip>(find.byKey(CheckoutKeys.window(slot)))
            .selected,
        isTrue,
      );
      if (kIsWeb) {
        expect(
          await currentLocation($),
          '/checkout/$sessionId?bags=$bags&slot=$slot',
        );
      }
      expect(confirmEnabled($), isFalse);

      await $(CheckoutKeys.card('card_visa_4242')).scrollTo().tap();
      expect(confirmEnabled($), isTrue);

      // Tap twice before any frame, so the second tap reaches the same handler.
      await $.tester.ensureVisible(find.byKey(CheckoutKeys.confirm));
      await $.tester.tap(find.byKey(CheckoutKeys.confirm));
      await $.tester.tap(find.byKey(CheckoutKeys.confirm));
      await $.pumpAndSettle();

      await $(OrdersKeys.orderId).waitUntilVisible();
      expect($('Order placed'), findsOneWidget);
      final orderId = $.tester
          .widget<Text>(find.byKey(OrdersKeys.orderId))
          .data!;
      expect(orderId, startsWith('ord_'));
      final orders = jsonDecode(
        preferences.getString('server.orders')!,
      ) as Map<String, dynamic>;
      expect(orders.keys, [orderId]);

      if (kIsWeb) {
        expect(await currentLocation($), '/orders/$orderId');
        await $.platform.web.goBack();
        await $.pumpAndSettle();
        await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
        expect(await currentLocation($), '/?bags=$bags');
        expect($(CheckoutKeys.confirm), findsNothing);
      }

      GoRouter.of($.tester.element(find.byKey(AppKeys.navBags)))
          .go('/checkout/cs_unknown?bags=bag_cafe');
      await $.pumpAndSettle();
      await $('Checkout not found').waitUntilVisible();
      expect($(CheckoutKeys.startAgain), findsOneWidget);

      await $(CheckoutKeys.startAgain).tap();
      await $(CheckoutKeys.confirm).waitUntilVisible();
      expect($('Café bag'), findsWidgets);
      if (kIsWeb) {
        expect(
          await currentLocation($),
          matches(RegExp(r'^/checkout/cs_[0-9a-f]{16}\?bags=bag_cafe$')),
        );
      }

      // A day-old slot is always passed, whatever the time of day.
      final router = GoRouter.of($.tester.element(find.byType(CheckoutPage)));
      final session = router.routerDelegate.currentConfiguration.uri.path;
      final passed = CollectionWindow(
        DateTime.now().subtract(const Duration(days: 1)),
      ).slotParam;
      router.go('$session?bags=bag_cafe&slot=$passed');
      await $.pumpAndSettle();
      await $(slotNotice).waitUntilVisible();
      expect(
        $.tester
            .widget<InlineNotice>(find.byKey(CheckoutKeys.errorNotice))
            .tone,
        InlineNoticeTone.error,
      );
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '$session?bags=bag_cafe',
      );
      if (kIsWeb) expect(await currentLocation($), '$session?bags=bag_cafe');
      expect(confirmEnabled($), isFalse);

      final fresh = firstSlot($);
      await $(CheckoutKeys.window(fresh)).scrollTo().tap();
      expect($(slotNotice), findsNothing);
      if (kIsWeb) {
        expect(await currentLocation($), '$session?bags=bag_cafe&slot=$fresh');
      }
    },
  );
}

Future<void> pick(PatrolIntegrationTester $, String id) =>
    $(CatalogKeys.bag(id)).scrollTo().tap();

String? total(PatrolIntegrationTester $) =>
    $.tester.widget<Text>(find.byKey(CheckoutKeys.summaryTotal)).data;

bool confirmEnabled(PatrolIntegrationTester $) =>
    $.tester.widget<AppButton>(find.byKey(CheckoutKeys.confirm)).onPressed !=
    null;

// The first offered window depends on the time of day, so read its key.
String firstSlot(PatrolIntegrationTester $) {
  final key =
      $.tester.widget<WindowChip>(find.byType(WindowChip).first).key!
          as ValueKey<String>;
  return key.value.replaceFirst('checkout-window-', '');
}

Future<String> currentLocation(PatrolIntegrationTester $) async {
  final url = Uri.parse(await $.platform.web.getCurrentPageUrl());
  return Uri.decodeFull(url.hasQuery ? '${url.path}?${url.query}' : url.path);
}

// Patrol skips its refill fix on web (flutter#134604), so type through the state.
Future<void> enterName(PatrolIntegrationTester $, String name) async {
  if (!kIsWeb) return $(AuthKeys.signInName).enterText(name);
  $.tester
      .state<EditableTextState>(
        find.descendant(
          of: find.byKey(AuthKeys.signInName),
          matching: find.byType(EditableText),
        ),
      )
      .userUpdateTextEditingValue(
        TextEditingValue(
          text: name,
          selection: TextSelection.collapsed(offset: name.length),
        ),
        SelectionChangedCause.keyboard,
      );
  await $.pumpAndSettle();
}
