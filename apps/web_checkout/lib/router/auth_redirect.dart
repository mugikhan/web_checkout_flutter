import 'package:auth/auth.dart';

import 'app_routes.dart';

/// authRedirect sends signed-out users to sign-in and signed-in users back.
String? authRedirect(SessionState session, Uri uri) {
  if (session is SessionChecking) return null;
  final signedIn = session is SessionSignedIn;

  if (uri.path == AppRoutes.signIn) {
    if (!signedIn) return null;
    return _localPath(uri.queryParameters['from']) ?? AppRoutes.bags;
  }
  if (!signedIn && AppRoutes.isGuarded(uri.path)) {
    return Uri(
      path: AppRoutes.signIn,
      queryParameters: {'from': uri.toString()},
    ).toString();
  }
  return null;
}

// Accept only same-app paths, so `from` cannot send the user to another site.
String? _localPath(String? from) {
  if (from == null || !from.startsWith('/')) return null;
  if (from.startsWith('//') || from.startsWith(r'/\')) return null;
  return from;
}
