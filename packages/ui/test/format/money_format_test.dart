import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

void main() {
  test('formats cents as en_ZA rand', () {
    expect(formatZar(5999), 'R59,99');
    expect(formatZar(0), 'R0,00');
  });

  test('groups thousands with a no-break space', () {
    expect(formatZar(123450), 'R1 234,50');
  });
}
