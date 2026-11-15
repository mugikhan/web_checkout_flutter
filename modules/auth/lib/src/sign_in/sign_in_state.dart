import 'package:api/domain/domain.dart';

enum SignInStatus { editing, submitting, succeeded }

enum SignInError { nameTooShort, unavailable }

/// SignInState holds the sign-in form: the name, its progress and any error.
class SignInState {
  const SignInState({
    this.name = '',
    this.status = SignInStatus.editing,
    this.error,
    this.minLength = ViewerName.minLength,
    this.viewer,
  });

  final String name;
  final SignInStatus status;
  final SignInError? error;

  /// The shortest name allowed, as the latest rejection reported it.
  final int minLength;

  /// The signed-in viewer, set once [status] is [SignInStatus.succeeded].
  final Viewer? viewer;

  @override
  bool operator ==(Object other) =>
      other is SignInState &&
      other.name == name &&
      other.status == status &&
      other.error == error &&
      other.minLength == minLength &&
      other.viewer == viewer;

  @override
  int get hashCode => Object.hash(name, status, error, minLength, viewer);

  @override
  String toString() =>
      'SignInState($name, ${status.name}, ${error?.name}, $minLength, $viewer)';
}
