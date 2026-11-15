/// AppRoutes holds the path of every route.
abstract final class AppRoutes {
  static const bags = '/';
  static const account = '/account';
  static const signIn = '/sign-in';
  static const checkoutNew = '/checkout/new';
  static const checkout = '/checkout/:sessionId';
  static const order = '/orders/:orderId';

  /// isGuarded is true for paths that need a signed-in viewer.
  static bool isGuarded(String path) =>
      path == account ||
      path.startsWith('/checkout/') ||
      path.startsWith('/orders/');

  /// bagIdsFrom reads the `bags` query as written, keeping order and duplicates.
  static List<String> bagIdsFrom(Uri uri) => [
    for (final id in (uri.queryParameters['bags'] ?? '').split(','))
      if (id.trim().isNotEmpty) id.trim(),
  ];

  /// slotFrom reads the `slot` query as written, or null when it is empty.
  static String? slotFrom(Uri uri) {
    final slot = uri.queryParameters['slot']?.trim();
    return slot == null || slot.isEmpty ? null : slot;
  }

  /// bagsLocation builds the Bags URL for [ids], with raw commas between them.
  static String bagsLocation(List<String> ids) => '$bags${_query(ids)}';

  static String checkoutStart(List<String> ids, {String? slot}) =>
      '$checkoutNew${_query(ids, slot: slot)}';

  static String checkoutLocation(
    String sessionId,
    List<String> ids, {
    String? slot,
  }) => '/checkout/$sessionId${_query(ids, slot: slot)}';

  static String orderLocation(String orderId) => '/orders/$orderId';

  // Keep commas and colons raw; ids and slots never need them encoded.
  static String _query(List<String> ids, {String? slot}) {
    final parts = [
      if (ids.isNotEmpty) 'bags=${ids.map(_encode).join(',')}',
      if (slot != null) 'slot=${_encode(slot)}',
    ];
    return parts.isEmpty ? '' : '?${parts.join('&')}';
  }

  static String _encode(String value) =>
      Uri.encodeQueryComponent(value).replaceAll('%3A', ':');
}
