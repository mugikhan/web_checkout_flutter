import 'viewer.dart';

/// SignInResult is the outcome of a sign-in request.
sealed class SignInResult {
  const SignInResult();
}

final class SignedIn extends SignInResult {
  const SignedIn(this.viewer);

  final Viewer viewer;

  @override
  bool operator ==(Object other) => other is SignedIn && other.viewer == viewer;

  @override
  int get hashCode => viewer.hashCode;
}

/// SignInFailure is an expected reason a sign-in request did not succeed.
sealed class SignInFailure extends SignInResult {
  const SignInFailure();
}

/// InvalidName means the "server" rejected the name's length.
final class InvalidName extends SignInFailure {
  const InvalidName({required this.minLength});

  final int minLength;

  @override
  bool operator ==(Object other) =>
      other is InvalidName && other.minLength == minLength;

  @override
  int get hashCode => minLength.hashCode;
}

/// SignInUnavailable means the request failed for an unexpected reason.
final class SignInUnavailable extends SignInFailure {
  const SignInUnavailable();

  @override
  bool operator ==(Object other) => other is SignInUnavailable;

  @override
  int get hashCode => (SignInUnavailable).hashCode;
}
