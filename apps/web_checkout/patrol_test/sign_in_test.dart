import 'package:auth/auth.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_checkout/app_keys.dart';
import 'package:web_checkout/main.dart' as app;

void main() {
  patrolTest('viewer signs in, sees Account and signs out', ($) async {
    await (await SharedPreferences.getInstance()).clear();
    await app.main();
    await $.pumpAndSettle();

    await $(AppKeys.navAccount).tap();
    expect($('Sign in'), findsWidgets);
    if (kIsWeb) expect(await currentLocation($), '/sign-in?from=/account');

    await enterName($, 'Bob');
    await $(AuthKeys.signInSubmit).tap();
    expect($('Enter at least 4 characters'), findsOneWidget);
    expect($(AuthKeys.signOut), findsNothing);
    if (kIsWeb) expect(await currentLocation($), '/sign-in?from=/account');

    await enterName($, 'Naledi');
    await $(AuthKeys.signInSubmit).tap();
    await $('Naledi').waitUntilVisible();
    expect($('Signed in as'), findsOneWidget);
    if (kIsWeb) expect(await currentLocation($), '/account');

    await $(AuthKeys.signOut).tap();
    await $(CatalogKeys.bag('bag_cafe')).waitUntilVisible();
    if (kIsWeb) expect(await currentLocation($), '/');

    await $(AppKeys.navAccount).tap();
    expect($(AuthKeys.signInName), findsOneWidget);
    if (kIsWeb) expect(await currentLocation($), '/sign-in?from=/account');
  });
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
