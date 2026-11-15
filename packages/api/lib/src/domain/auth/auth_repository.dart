import '../api_fault.dart';
import 'sign_in_result.dart';
import 'viewer.dart';

/// AuthRepository signs the viewer in and out and restores the session.
abstract interface class AuthRepository {
  Future<SignInResult> signIn(String name);

  /// currentViewer returns null when signed out and throws [ApiFault] on a fault.
  Future<Viewer?> currentViewer();

  Future<void> signOut();
}
