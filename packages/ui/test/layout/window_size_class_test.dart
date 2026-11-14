import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

void main() {
  final cases = {
    599.0: WindowSizeClass.compact,
    600.0: WindowSizeClass.medium,
    839.0: WindowSizeClass.medium,
    840.0: WindowSizeClass.expanded,
  };
  for (final MapEntry(key: width, value: expected) in cases.entries) {
    test('$width px is $expected', () {
      expect(WindowSizeClass.fromWidth(width), expected);
    });
  }
}
