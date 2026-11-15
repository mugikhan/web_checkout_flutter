import 'dart:async';

import 'package:api/domain/domain.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui/ui.dart';

import 'support/mocks.dart';
import 'support/pump_catalog.dart';

void main() {
  late MockCatalogRepository repository;

  setUp(() {
    repository = MockCatalogRepository();
    when(() => repository.bags())
        .thenAnswer((_) async => const BagsLoaded(allBags));
  });

  BagTile tile(WidgetTester tester, String id) =>
      tester.widget<BagTile>(find.byKey(CatalogKeys.bag(id)));

  String text(WidgetTester tester, Key key) =>
      tester.widget<Text>(find.byKey(key)).data!;

  Future<void> tap(WidgetTester tester, String id) async {
    await tester.ensureVisible(find.byKey(CatalogKeys.bag(id)));
    await tester.tap(find.byKey(CatalogKeys.bag(id)));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a loading view until the bags arrive', (tester) async {
    final gate = Completer<BagsResult>();
    when(() => repository.bags()).thenAnswer((_) => gate.future);

    await pumpCatalog(tester, repository, settle: false);
    expect(find.text('Loading bags'), findsOneWidget);

    gate.complete(const BagsLoaded(allBags));
    await tester.pumpAndSettle();
    expect(find.text('Café bag'), findsOneWidget);
  });

  testWidgets('a failure shows the error view and retry loads the bags', (
    tester,
  ) async {
    when(() => repository.bags())
        .thenAnswer((_) async => const BagsUnavailable());
    await pumpCatalog(tester, repository);

    expect(find.text('Bags could not load'), findsOneWidget);

    when(() => repository.bags())
        .thenAnswer((_) async => const BagsLoaded(allBags));
    await tester.tap(find.byKey(CatalogKeys.retry));
    await tester.pumpAndSettle();

    expect(find.text('Grocery bag'), findsOneWidget);
    verify(() => repository.bags()).called(2);
  });

  testWidgets('lists every bag with its price and worth', (tester) async {
    await pumpCatalog(tester, repository);

    expect(
      find.text('Surplus bags from Corner Pantry. Pick up to 2.'),
      findsOneWidget,
    );
    for (final bag in allBags) {
      expect(find.byKey(CatalogKeys.bag(bag.id)), findsOneWidget);
    }
    expect(find.text('R59,99'), findsOneWidget);
    expect(find.text('R180,00'), findsOneWidget);
    expect(text(tester, CatalogKeys.summaryCount), 'No bags picked');
    expect(text(tester, CatalogKeys.summaryTotal), 'R0,00');
  });

  testWidgets('two picks fill the URL, the summary and the limit', (
    tester,
  ) async {
    final changes = await pumpCatalog(tester, repository);

    await tap(tester, 'bag_cafe');
    await tap(tester, 'bag_bakery');

    expect(changes, [
      ['bag_cafe'],
      ['bag_cafe', 'bag_bakery'],
    ]);
    expect(tile(tester, 'bag_cafe').selected, isTrue);
    expect(tile(tester, 'bag_bakery').selected, isTrue);
    expect(text(tester, CatalogKeys.summaryCount), '2 bags');
    expect(text(tester, CatalogKeys.summaryTotal), 'R109,98');
    expect(tile(tester, 'bag_grocery').enabled, isFalse);
    expect(tile(tester, 'bag_surprise').enabled, isFalse);
    expect(find.text('You can pick up to 2 bags'), findsNWidgets(2));

    await tap(tester, 'bag_grocery');
    expect(changes, hasLength(2));

    await tap(tester, 'bag_bakery');
    expect(changes.last, ['bag_cafe']);
    expect(tile(tester, 'bag_grocery').enabled, isTrue);
    expect(find.text('You can pick up to 2 bags'), findsNothing);
    expect(text(tester, CatalogKeys.summaryCount), '1 bag');

    verify(() => repository.bags()).called(1);
  });

  testWidgets('a bad link asks for the clean URL once and shows the notice', (
    tester,
  ) async {
    final changes = await pumpCatalog(
      tester,
      repository,
      bagIds: [
        'bag_unknown',
        'bag_cafe',
        'bag_cafe',
        'bag_bakery',
        'bag_grocery',
      ],
    );

    expect(changes, [
      ['bag_cafe', 'bag_bakery'],
    ]);
    expect(tile(tester, 'bag_cafe').selected, isTrue);
    expect(tile(tester, 'bag_bakery').selected, isTrue);
    expect(tile(tester, 'bag_grocery').selected, isFalse);
    expect(
      find.text('A max of 2 bags can be selected, some bags were removed'),
      findsOneWidget,
    );

    expect(
      tester.widget<InlineNotice>(find.byKey(CatalogKeys.notice)).tone,
      InlineNoticeTone.error,
    );

    await tester.tap(find.byKey(CatalogKeys.noticeDismiss));
    await tester.pumpAndSettle();
    expect(find.byKey(CatalogKeys.notice), findsNothing);
    expect(tile(tester, 'bag_cafe').selected, isTrue);
  });

  testWidgets('a clean link shows its picks and no notice', (tester) async {
    final changes = await pumpCatalog(
      tester,
      repository,
      bagIds: ['bag_grocery'],
    );

    expect(changes, isEmpty);
    expect(tile(tester, 'bag_grocery').selected, isTrue);
    expect(find.byKey(CatalogKeys.notice), findsNothing);
  });

  testWidgets('compact windows show one column', (tester) async {
    await pumpCatalog(tester, repository);

    final grocery = tester.getTopLeft(
      find.byKey(CatalogKeys.bag('bag_grocery')),
    );
    final cafe = tester.getTopLeft(find.byKey(CatalogKeys.bag('bag_cafe')));
    expect(cafe.dx, grocery.dx);
    expect(cafe.dy, greaterThan(grocery.dy));
  });

  testWidgets('medium and expanded windows show two columns', (tester) async {
    for (final width in [700.0, 1200.0]) {
      await pumpCatalog(tester, repository, size: Size(width, 900));

      final grocery = find.byKey(CatalogKeys.bag('bag_grocery'));
      final cafe = find.byKey(CatalogKeys.bag('bag_cafe'));
      expect(tester.getTopLeft(cafe).dy, tester.getTopLeft(grocery).dy);
      expect(
        tester.getTopLeft(cafe).dx,
        greaterThan(tester.getTopLeft(grocery).dx),
      );
      expect(tester.getSize(cafe).height, tester.getSize(grocery).height);
    }
  });

  AppButton continueButton(WidgetTester tester) =>
      tester.widget<AppButton>(find.byKey(CatalogKeys.continueButton));

  testWidgets('Continue is disabled with nothing picked', (tester) async {
    await pumpCatalog(tester, repository);

    expect(continueButton(tester).onPressed, isNull);
  });

  testWidgets('Continue hands the picks to the app', (tester) async {
    final continues = <List<String>>[];
    await pumpCatalog(tester, repository, continues: continues);

    await tap(tester, 'bag_cafe');
    expect(continueButton(tester).onPressed, isNotNull);
    await tap(tester, 'bag_bakery');
    await tester.tap(find.byKey(CatalogKeys.continueButton));

    expect(continues, [
      ['bag_cafe', 'bag_bakery'],
    ]);
  });

  testWidgets('Continue announces its label and enabled state', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpCatalog(tester, repository, bagIds: ['bag_cafe']);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Continue')),
      isSemantics(
        label: 'Continue',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
    semantics.dispose();
  });
}
