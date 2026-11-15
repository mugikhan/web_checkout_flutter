import 'package:flutter_test/flutter_test.dart';
import 'package:web_checkout/router/app_routes.dart';

void main() {
  group('bagIdsFrom', () {
    List<String> ids(String location) =>
        AppRoutes.bagIdsFrom(Uri.parse(location));

    test('reads nothing without a bags query', () {
      expect(ids('/'), isEmpty);
      expect(ids('/?bags='), isEmpty);
    });

    test('reads ids in order and keeps duplicates', () {
      expect(ids('/?bags=bag_cafe,bag_bakery,bag_cafe'), [
        'bag_cafe',
        'bag_bakery',
        'bag_cafe',
      ]);
    });

    test('trims spaces and drops empty ids', () {
      expect(ids('/?bags=%20bag_cafe%20,,bag_bakery,'), [
        'bag_cafe',
        'bag_bakery',
      ]);
    });

    test('reads encoded commas', () {
      expect(ids('/?bags=bag_cafe%2Cbag_bakery'), ['bag_cafe', 'bag_bakery']);
    });
  });

  group('bagsLocation', () {
    test('is / without ids', () {
      expect(AppRoutes.bagsLocation([]), '/');
    });

    test('joins ids with raw commas', () {
      expect(
        AppRoutes.bagsLocation(['bag_cafe', 'bag_bakery']),
        '/?bags=bag_cafe,bag_bakery',
      );
    });
  });

  group('isGuarded', () {
    test('guards Account, checkout and orders', () {
      for (final path in [
        '/account',
        '/checkout/new',
        '/checkout/cs_1',
        '/orders/ord_1',
      ]) {
        expect(AppRoutes.isGuarded(path), isTrue, reason: path);
      }
    });

    test('leaves Bags, sign-in and unknown paths public', () {
      for (final path in ['/', '/sign-in', '/checkout', '/does-not-exist']) {
        expect(AppRoutes.isGuarded(path), isFalse, reason: path);
      }
    });
  });

  group('slotFrom', () {
    test('reads the slot or null', () {
      expect(
        AppRoutes.slotFrom(Uri.parse('/x?slot=2026-11-15T12:00Z')),
        '2026-11-15T12:00Z',
      );
      expect(AppRoutes.slotFrom(Uri.parse('/x?slot=')), isNull);
      expect(AppRoutes.slotFrom(Uri.parse('/x')), isNull);
    });
  });

  group('checkout locations', () {
    test('checkoutStart keeps bags and the slot raw', () {
      expect(
        AppRoutes.checkoutStart(['bag_cafe', 'bag_bakery']),
        '/checkout/new?bags=bag_cafe,bag_bakery',
      );
      expect(
        AppRoutes.checkoutStart(['bag_cafe'], slot: '2026-11-15T12:00Z'),
        '/checkout/new?bags=bag_cafe&slot=2026-11-15T12:00Z',
      );
    });

    test('checkoutLocation names the session', () {
      expect(
        AppRoutes.checkoutLocation('cs_1', ['bag_cafe']),
        '/checkout/cs_1?bags=bag_cafe',
      );
      expect(
        AppRoutes.checkoutLocation('cs_1', ['bag_cafe'], slot: 'a&b'),
        '/checkout/cs_1?bags=bag_cafe&slot=a%26b',
      );
    });

    test('orderLocation names the order', () {
      expect(AppRoutes.orderLocation('ord_1'), '/orders/ord_1');
    });
  });
}
