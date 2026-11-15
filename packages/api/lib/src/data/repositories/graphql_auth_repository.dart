import 'package:graphql/client.dart';

import '../../domain/api_fault.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/sign_in_result.dart';
import '../../domain/auth/viewer.dart';
import '../graphql/auth.graphql.dart';
import 'token_store.dart';

/// GraphqlAuthRepository implements [AuthRepository] over the GraphQL client.
class GraphqlAuthRepository implements AuthRepository {
  GraphqlAuthRepository({required this._client, required this._tokens});

  final GraphQLClient _client;
  final TokenStore _tokens;

  @override
  Future<SignInResult> signIn(String name) async {
    final result = await _client.mutate$SignIn(
      Options$Mutation$SignIn(
        variables: Variables$Mutation$SignIn(name: name.trim()),
      ),
    );
    final data = result.parsedData;
    if (result.hasException || data == null) return const SignInUnavailable();

    switch (data.signIn) {
      case Mutation$SignIn$signIn$$SignInSuccess(:final token, :final viewer):
        await _tokens.write(token);
        return SignedIn(_toViewer(viewer));
      case Mutation$SignIn$signIn$$InvalidName(:final minLength):
        return InvalidName(minLength: minLength);
      default:
        return const SignInUnavailable();
    }
  }

  @override
  Future<Viewer?> currentViewer() async {
    if (await _tokens.read() == null) return null;

    final result = await _client.query$Viewer();
    final data = result.parsedData;
    if (result.hasException || data == null) {
      throw ApiFault(result.exception?.toString() ?? 'Viewer query failed.');
    }
    final viewer = data.viewer;
    if (viewer == null) {
      await _tokens.delete();
      return null;
    }
    return _toViewer(viewer);
  }

  @override
  Future<void> signOut() => _tokens.delete();

  static Viewer _toViewer(Fragment$ViewerFields fields) =>
      Viewer(id: fields.id, name: fields.name);
}
