import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

void main() {
  test('formats local time as two-digit hours and minutes', () {
    expect(formatClock(DateTime(2026, 11, 15, 9, 5)), '09:05');
    expect(formatClock(DateTime(2026, 11, 15, 14)), '14:00');
    expect(formatClock(DateTime(2026, 11, 15)), '00:00');
  });

  test('converts a UTC instant to local time', () {
    final utc = DateTime.utc(2026, 11, 15, 12);
    expect(formatClock(utc), formatClock(utc.toLocal()));
  });
}
