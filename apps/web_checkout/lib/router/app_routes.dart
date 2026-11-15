/// AppRoutes holds the path of every route.
abstract final class AppRoutes {
  static const bags = '/';
  static const account = '/account';
  static const signIn = '/sign-in';

  /// guarded lists the paths that need a signed-in viewer.
  static const guarded = {account};

  /// bagIdsFrom reads the `bags` query as written, keeping order and duplicates.
  static List<String> bagIdsFrom(Uri uri) => [
    for (final id in (uri.queryParameters['bags'] ?? '').split(','))
      if (id.trim().isNotEmpty) id.trim(),
  ];

  /// bagsLocation builds the Bags URL for [ids], with raw commas between them.
  static String bagsLocation(List<String> ids) =>
      ids.isEmpty ? bags : '$bags?bags=${ids.join(',')}';
}
