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

const settleTimeout = Duration(seconds: 20);
const declineReason =
    'The payment was declined and you were not charged. '
    'Try placing the order again';

void main() {
  patrolTest(
    'a Visa order confirms, a Mastercard order fails and an unknown order is '
    'not found',
    ($) async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      await app.main();
      await $.pumpAndSettle();

      await pick($, 'bag_cafe');
      await pick($, 'bag_bakery');
      await $(CatalogKeys.continueButton).tap();
      await $(AuthKeys.signInName).waitUntilVisible();
      await enterName($, 'Naledi');
      await $(AuthKeys.signInSubmit).tap();

      await payWith($, 'card_visa_4242');
      await $(OrdersKeys.orderId).waitUntilVisible();
      final visaOrderId = text($, OrdersKeys.orderId);
      expect(visaOrderId, startsWith('ord_'));
      expect($('Order placed'), findsOneWidget);
      expect(text($, OrdersKeys.store), 'Corner Pantry');
      expect($('Café bag'), findsOneWidget);
      expect($('R59,99'), findsOneWidget);
      expect($('Bakery bag'), findsOneWidget);
      expect($('R49,99'), findsOneWidget);
      expect(text($, OrdersKeys.total), 'R109,98');
      expect(text($, OrdersKeys.card), 'Visa •••• 4242');
      expect($(OrdersKeys.window), findsOneWidget);
      expect(marker($, 1), scheme($).primary);
      expect(marker($, 2), scheme($).onSurfaceVariant);
      expect($(OrdersKeys.backToBags), findsNothing);
      if (kIsWeb) {
        expect(await currentPath($), '/orders/$visaOrderId');
      }

      await $(OrdersKeys.backToBags).waitUntilExists(timeout: settleTimeout);
      expect(marker($, 2), scheme($).primary);
      expect($(OrdersKeys.declineNotice), findsNothing);
      expect(
        $.tester.widget<Icon>(find.byKey(StatusTimeline.markerKey(2))).icon,
        Icons.check_circle,
      );
      await $(OrdersKeys.backToBags).scrollTo().tap();
      await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
      expect(
        $.tester
            .widget<BagTile>(find.byKey(CatalogKeys.bag('bag_cafe')))
            .selected,
        isFalse,
      );
      if (kIsWeb) expect(await currentPath($), '/');

      await pick($, 'bag_cafe');
      await pick($, 'bag_bakery');
      await $(CatalogKeys.continueButton).tap();
      await payWith($, 'card_mastercard_0002');
      await $(OrdersKeys.orderId).waitUntilVisible();
      expect(text($, OrdersKeys.orderId), isNot(visaOrderId));
      expect(text($, OrdersKeys.card), 'Mastercard •••• 0002');
      expect(marker($, 2), scheme($).onSurfaceVariant);
      expect($(OrdersKeys.backToBags), findsNothing);

      await $(OrdersKeys.declineNotice)
          .waitUntilVisible(timeout: settleTimeout);
      expect($('Failed'), findsOneWidget);
      expect(marker($, 2), scheme($).error);
      final notice = $.tester.widget<InlineNotice>(
        find.byKey(OrdersKeys.declineNotice),
      );
      expect(notice.tone, InlineNoticeTone.error);
      expect(notice.message, declineReason);
      expect($(declineReason), findsOneWidget);
      expect($(OrdersKeys.backToBags), findsOneWidget);
      await $(OrdersKeys.backToBags).scrollTo();

      GoRouter.of($.tester.element(find.byKey(AppKeys.navBags)))
          .go('/orders/ord_missing');
      await $('Order not found').waitUntilVisible();
      expect($('Order placed'), findsNothing);
      if (kIsWeb) expect(await currentPath($), '/orders/ord_missing');
      await $(OrdersKeys.backToBags).tap();
      await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
      if (kIsWeb) expect(await currentPath($), '/');
    },
  );
}

Future<void> pick(PatrolIntegrationTester $, String id) =>
    $(CatalogKeys.bag(id)).scrollTo().tap();

Future<void> payWith(PatrolIntegrationTester $, String cardId) async {
  await $(CheckoutKeys.confirm).waitUntilVisible();
  await $(CheckoutKeys.window(firstSlot($))).scrollTo().tap();
  await $(CheckoutKeys.card(cardId)).scrollTo().tap();
  await $(CheckoutKeys.confirm).scrollTo().tap();
}

String? text(PatrolIntegrationTester $, Key key) =>
    $.tester.widget<Text>(find.byKey(key)).data;

ColorScheme scheme(PatrolIntegrationTester $) =>
    Theme.of($.tester.element(find.byKey(OrdersKeys.timeline))).colorScheme;

Color? marker(PatrolIntegrationTester $, int index) =>
    $.tester.widget<Icon>(find.byKey(StatusTimeline.markerKey(index))).color;

// The first offered window depends on the time of day, so read its key.
String firstSlot(PatrolIntegrationTester $) {
  final key =
      $.tester.widget<WindowChip>(find.byType(WindowChip).first).key!
          as ValueKey<String>;
  return key.value.replaceFirst('checkout-window-', '');
}

Future<String> currentPath(PatrolIntegrationTester $) async =>
    Uri.parse(await $.platform.web.getCurrentPageUrl()).path;

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
