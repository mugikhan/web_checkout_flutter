import '../graphql/auth.graphql.dart';
import '../link/request_context.dart';
import 'session_store.dart';

/// AuthResolvers answers the signIn mutation and the viewer query.
class AuthResolvers {
  AuthResolvers(this._sessions);

  // The "server" keeps its own copy of the rule, apart from the client's.
  static const minNameLength = 4;

  final SessionStore _sessions;

  Future<Mutation$SignIn> signIn(Variables$Mutation$SignIn variables) async {
    final name = variables.name.trim();
    if (name.length < minNameLength) {
      return Mutation$SignIn(
        signIn: Mutation$SignIn$signIn$$InvalidName(minLength: minNameLength),
      );
    }
    final token = await _sessions.create(name);
    return Mutation$SignIn(
      signIn: Mutation$SignIn$signIn$$SignInSuccess(
        token: token,
        viewer: _viewer(name),
      ),
    );
  }

  Future<Query$Viewer> viewer(RequestContext context) async {
    final token = context.token;
    final name = token == null ? null : await _sessions.nameFor(token);
    return Query$Viewer(viewer: name == null ? null : _viewer(name));
  }

  /// viewerId derives the stable viewer id that owns sessions and orders.
  static String viewerId(String name) => 'viewer:${name.toLowerCase()}';

  static Fragment$ViewerFields _viewer(String name) =>
      Fragment$ViewerFields(id: viewerId(name), name: name);
}
