import 'dart:async';

import 'package:api/domain/domain.dart';

/// FakeAuthRepository records calls and returns canned results.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.viewer,
    this.signInResult = const SignedIn(naledi),
    this.currentViewerFault = false,
  });

  static const naledi = Viewer(id: 'viewer:naledi', name: 'Naledi');

  Viewer? viewer;
  SignInResult signInResult;
  bool currentViewerFault;

  /// signInGate holds signIn open until the test completes it.
  Completer<void>? signInGate;

  final signInCalls = <String>[];
  var signOutCalls = 0;

  @override
  Future<SignInResult> signIn(String name) async {
    signInCalls.add(name);
    await signInGate?.future;
    if (signInResult case SignedIn(viewer: final signedIn)) viewer = signedIn;
    return signInResult;
  }

  @override
  Future<Viewer?> currentViewer() async {
    if (currentViewerFault) throw const ApiFault('boom');
    return viewer;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    viewer = null;
  }
}
