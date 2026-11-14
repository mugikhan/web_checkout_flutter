import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:patrol/patrol.dart';
import 'package:web_checkout/main.dart' as app;

void main() {
  patrolTest('app launches on the home screen', ($) async {
    app.main();
    await $.pumpAndSettle();

    expect($('Bag Checkout'), findsOneWidget);

    if (kIsWeb) {
      expect(urlStrategy, isA<PathUrlStrategy>());
      final url = Uri.parse(await $.platform.web.getCurrentPageUrl());
      expect(url.fragment, isEmpty);
    }
  });
}
