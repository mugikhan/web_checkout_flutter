import 'package:api/domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_checkout/router/auth_redirect.dart';

void main() {
  const viewer = Viewer(id: 'viewer:naledi', name: 'Naledi');
  const signedIn = SessionSignedIn(viewer);
  const signedOut = SessionSignedOut();

  String? redirect(SessionState session, String location) =>
      authRedirect(session, Uri.parse(location));

  test('leaves every location alone while the session is checking', () {
    expect(redirect(const SessionChecking(), '/account'), isNull);
    expect(redirect(const SessionChecking(), '/sign-in'), isNull);
  });

  test('sends a signed-out user on /account to sign-in with from', () {
    expect(redirect(signedOut, '/account'), '/sign-in?from=%2Faccount');
  });

  test('keeps public and unknown paths for a signed-out user', () {
    expect(redirect(signedOut, '/'), isNull);
    expect(redirect(signedOut, '/does-not-exist'), isNull);
    expect(redirect(signedOut, '/sign-in?from=%2Faccount'), isNull);
  });

  test('keeps a signed-in viewer on guarded and public paths', () {
    expect(redirect(signedIn, '/account'), isNull);
    expect(redirect(signedIn, '/'), isNull);
  });

  test('sends a signed-in viewer on /sign-in to from, or to /', () {
    expect(redirect(signedIn, '/sign-in?from=%2Faccount'), '/account');
    expect(redirect(signedIn, '/sign-in'), '/');
  });

  test('ignores a from that leaves the app', () {
    for (final from in [
      'https://example.com',
      '//example.com',
      r'/\example.com',
      'account',
    ]) {
      final location = Uri(
        path: '/sign-in',
        queryParameters: {'from': from},
      ).toString();
      expect(redirect(signedIn, location), '/', reason: from);
    }
  });
}
