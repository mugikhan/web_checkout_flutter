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
}
