import 'package:api/domain/domain.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui/ui.dart';
import 'package:web_checkout/app_keys.dart';

import 'support/pump_app.dart';

void main() {
  BagTile tile(WidgetTester tester, String id) =>
      tester.widget<BagTile>(find.byKey(CatalogKeys.bag(id)));

  Future<void> tap(WidgetTester tester, String id) async {
    await tester.ensureVisible(find.byKey(CatalogKeys.bag(id)));
    await tester.tap(find.byKey(CatalogKeys.bag(id)));
    await tester.pumpAndSettle();
  }

  testWidgets('picks go into the URL and the bags load once', (tester) async {
    final catalog = mockCatalogRepository();
    await pumpApp(tester, catalog: catalog);

    await tap(tester, 'bag_cafe');
    expect(currentLocation(tester), '/?bags=bag_cafe');

    await tap(tester, 'bag_bakery');
    expect(currentLocation(tester), '/?bags=bag_cafe,bag_bakery');
    expect(tile(tester, 'bag_grocery').enabled, isFalse);

    await tap(tester, 'bag_cafe');
    await tap(tester, 'bag_bakery');
    expect(currentLocation(tester), '/');

    verify(() => catalog.bags()).called(1);
  });

  testWidgets('a deep link with picks shows them', (tester) async {
    await pumpApp(tester, location: '/?bags=bag_cafe,bag_bakery');

    expect(tile(tester, 'bag_cafe').selected, isTrue);
    expect(tile(tester, 'bag_bakery').selected, isTrue);
    expect(
      tester.widget<Text>(find.byKey(CatalogKeys.summaryCount)).data,
      '2 bags',
    );
    expect(currentLocation(tester), '/?bags=bag_cafe,bag_bakery');
  });

  testWidgets('a bad link is cleaned in the URL and shows the notice', (
    tester,
  ) async {
    await pumpApp(
      tester,
      location: '/?bags=bag_unknown,bag_cafe,bag_cafe,bag_bakery,bag_grocery',
    );

    expect(currentLocation(tester), '/?bags=bag_cafe,bag_bakery');
    expect(tile(tester, 'bag_cafe').selected, isTrue);
    expect(tile(tester, 'bag_bakery').selected, isTrue);
    expect(tile(tester, 'bag_grocery').selected, isFalse);
    expect(find.text('Some bags from the link were left out.'), findsOneWidget);
  });

  testWidgets('a link with only unknown ids is cleaned to /', (tester) async {
    await pumpApp(tester, location: '/?bags=bag_unknown');

    expect(currentLocation(tester), '/');
    expect(find.byKey(CatalogKeys.notice), findsOneWidget);
  });

  testWidgets('returning to Bags keeps the picks', (tester) async {
    await pumpApp(
      tester,
      location: '/?bags=bag_cafe',
      repository: mockAuthRepository(viewer: naledi),
    );

    await tester.tap(find.byKey(AppKeys.navAccount));
    await tester.pumpAndSettle();
    expect(currentLocation(tester), '/account');

    await tester.tap(find.byKey(AppKeys.navBags));
    await tester.pumpAndSettle();
    expect(currentLocation(tester), '/?bags=bag_cafe');
    expect(tile(tester, 'bag_cafe').selected, isTrue);
  });

  testWidgets('a load failure shows the error view with retry', (tester) async {
    final catalog = MockCatalogRepository();
    when(() => catalog.bags()).thenAnswer((_) async => const BagsUnavailable());
    await pumpApp(tester, catalog: catalog);

    expect(find.text('Bags could not load'), findsOneWidget);
    expect(find.byKey(CatalogKeys.retry), findsOneWidget);
  });
}
