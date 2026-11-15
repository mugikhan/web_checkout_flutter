import 'package:api/domain/domain.dart';

sealed class SessionState {
  const SessionState();
}

final class SessionChecking extends SessionState {
  const SessionChecking();

  @override
  bool operator ==(Object other) => other is SessionChecking;

  @override
  int get hashCode => (SessionChecking).hashCode;
}

final class SessionSignedIn extends SessionState {
  const SessionSignedIn(this.viewer);

  final Viewer viewer;

  @override
  bool operator ==(Object other) =>
      other is SessionSignedIn && other.viewer == viewer;

  @override
  int get hashCode => viewer.hashCode;
}

final class SessionSignedOut extends SessionState {
  const SessionSignedOut();

  @override
  bool operator ==(Object other) => other is SessionSignedOut;

  @override
  int get hashCode => (SessionSignedOut).hashCode;
}
