import 'package:api/domain/domain.dart';

sealed class SessionEvent {
  const SessionEvent();
}

/// SessionCheckRequested restores the session from the stored token.
final class SessionCheckRequested extends SessionEvent {
  const SessionCheckRequested();
}

final class ViewerSignedIn extends SessionEvent {
  const ViewerSignedIn(this.viewer);

  final Viewer viewer;
}

final class SignOutRequested extends SessionEvent {
  const SignOutRequested();
}
