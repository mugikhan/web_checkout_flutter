import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<DateTime> localStarts(DateTime now) => [
    for (final window in CollectionWindow.offered(now)) window.start.toLocal(),
  ];

  group('offered', () {
    test('at 08:30 offers every window today and tomorrow', () {
      final starts = localStarts(DateTime(2026, 11, 15, 8, 30));

      expect(starts, hasLength(26));
      expect(starts.first, DateTime(2026, 11, 15, 9));
      expect(starts[12], DateTime(2026, 11, 15, 21));
      expect(starts[13], DateTime(2026, 11, 16, 9));
      expect(starts.last, DateTime(2026, 11, 16, 21));
    });

    test('at 13:00 hides the windows that already started', () {
      final starts = localStarts(DateTime(2026, 11, 15, 13));

      expect(starts.first, DateTime(2026, 11, 15, 14));
      expect(starts.where((s) => s.day == 15), hasLength(8));
      expect(starts.where((s) => s.day == 16), hasLength(13));
    });

    test('at 21:30 offers only tomorrow', () {
      final starts = localStarts(DateTime(2026, 11, 15, 21, 30));

      expect(starts, hasLength(13));
      expect(starts.first, DateTime(2026, 11, 16, 9));
    });

    test('stores starts in UTC and lasts one hour', () {
      final window = CollectionWindow.offered(DateTime(2026, 11, 15, 8)).first;

      expect(window.start.isUtc, isTrue);
      expect(window.end.difference(window.start), const Duration(hours: 1));
    });
  });

  group('slot', () {
    final window = CollectionWindow(DateTime.utc(2026, 11, 15, 12));

    test('slotParam writes the compact UTC form', () {
      expect(window.slotParam, '2026-11-15T12:00Z');
    });

    test('parseSlot reads the compact and the full ISO form', () {
      expect(CollectionWindow.parseSlot('2026-11-15T12:00Z'), window.start);
      expect(
        CollectionWindow.parseSlot('2026-11-15T12:00:00.000Z'),
        window.start,
      );
      expect(
        CollectionWindow.parseSlot('2026-11-15T14:00+02:00'),
        window.start,
      );
    });

    test('parseSlot rejects missing, local and malformed values', () {
      expect(CollectionWindow.parseSlot(null), isNull);
      expect(CollectionWindow.parseSlot('2026-11-15T12:00'), isNull);
      expect(CollectionWindow.parseSlot('noon'), isNull);
    });

    test('windows with the same start are equal', () {
      expect(
        CollectionWindow(DateTime.utc(2026, 11, 15, 12)),
        CollectionWindow(DateTime.utc(2026, 11, 15, 12)),
      );
    });
  });
}
