/// AppRoutes holds the path of every route.
abstract final class AppRoutes {
  static const bags = '/';
  static const account = '/account';
  static const signIn = '/sign-in';

  /// guarded lists the paths that need a signed-in viewer.
  static const guarded = {account};
}
