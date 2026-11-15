/// BagSelection holds the rules for which bags a draft may hold.
abstract final class BagSelection {
  static const maxBags = 2;

  /// clean keeps known ids once each, in order, up to [maxBags].
  static List<String> clean(Iterable<String> ids, Set<String> knownIds) {
    final kept = <String>[];
    for (final id in ids) {
      if (kept.length == maxBags) break;
      if (knownIds.contains(id) && !kept.contains(id)) kept.add(id);
    }
    return kept;
  }

  /// canPick is true when [id] is picked already or the draft has room.
  static bool canPick(List<String> picked, String id) =>
      picked.contains(id) || picked.length < maxBags;

  /// toggle removes a picked [id], or adds it when the draft has room.
  static List<String> toggle(List<String> picked, String id) {
    if (picked.contains(id)) return [...picked]..remove(id);
    if (picked.length >= maxBags) return [...picked];
    return [...picked, id];
  }
}
