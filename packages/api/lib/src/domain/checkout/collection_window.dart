/// CollectionWindow is a 1-hour period when the customer collects bags.
final class CollectionWindow {
  CollectionWindow(DateTime start) : start = start.toUtc();

  static const length = Duration(hours: 1);
  static const firstHour = 9;
  static const lastHour = 21;

  /// start is the window's first instant, in UTC.
  final DateTime start;

  DateTime get end => start.add(length);

  /// offered lists today's and tomorrow's windows, in local time, that start after [now].
  static List<CollectionWindow> offered(DateTime now) {
    final local = now.toLocal();
    return [
      for (var day = 0; day < 2; day++)
        for (var hour = firstHour; hour <= lastHour; hour++)
          DateTime(local.year, local.month, local.day + day, hour),
    ].where((start) => start.isAfter(now)).map(CollectionWindow.new).toList();
  }

  /// slotParam writes [start] in the compact UTC form the URL uses.
  String get slotParam {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${start.year}-${two(start.month)}-${two(start.day)}'
        'T${two(start.hour)}:${two(start.minute)}Z';
  }

  /// parseSlot reads an ISO-8601 instant, or returns null for anything else.
  static DateTime? parseSlot(String? slot) {
    if (slot == null) return null;
    final parsed = DateTime.tryParse(slot);
    if (parsed == null || !parsed.isUtc) return null;
    return parsed;
  }

  @override
  bool operator ==(Object other) =>
      other is CollectionWindow && other.start == start;

  @override
  int get hashCode => start.hashCode;

  @override
  String toString() => 'CollectionWindow($slotParam)';
}
