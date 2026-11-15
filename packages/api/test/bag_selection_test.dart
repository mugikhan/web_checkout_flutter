import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const known = {'bag_grocery', 'bag_cafe', 'bag_bakery', 'bag_surprise'};

  group('clean', () {
    test('keeps a valid link as it is', () {
      expect(BagSelection.clean(['bag_cafe', 'bag_bakery'], known), [
        'bag_cafe',
        'bag_bakery',
      ]);
    });

    test('drops unknown ids and duplicates and keeps the first 2', () {
      expect(
        BagSelection.clean([
          'bag_unknown',
          'bag_cafe',
          'bag_cafe',
          'bag_bakery',
          'bag_grocery',
        ], known),
        ['bag_cafe', 'bag_bakery'],
      );
    });

    test('returns nothing for only unknown ids or no ids', () {
      expect(BagSelection.clean(['bag_unknown'], known), isEmpty);
      expect(BagSelection.clean([], known), isEmpty);
    });
  });

  group('toggle', () {
    test('adds an unpicked bag when there is room', () {
      expect(BagSelection.toggle(['bag_cafe'], 'bag_bakery'), [
        'bag_cafe',
        'bag_bakery',
      ]);
    });

    test('removes a picked bag', () {
      expect(BagSelection.toggle(['bag_cafe', 'bag_bakery'], 'bag_cafe'), [
        'bag_bakery',
      ]);
    });

    test('ignores a third bag', () {
      expect(BagSelection.toggle(['bag_cafe', 'bag_bakery'], 'bag_grocery'), [
        'bag_cafe',
        'bag_bakery',
      ]);
    });
  });

  test('canPick allows picked bags and bags while there is room', () {
    expect(BagSelection.canPick(['bag_cafe'], 'bag_bakery'), isTrue);
    expect(
      BagSelection.canPick(['bag_cafe', 'bag_bakery'], 'bag_cafe'),
      isTrue,
    );
    expect(
      BagSelection.canPick(['bag_cafe', 'bag_bakery'], 'bag_grocery'),
      isFalse,
    );
  });

  test('Money adds cents', () {
    expect(const Money(5999) + const Money(4999), const Money(10998));
    expect(Money.zero, const Money(0));
  });
}
