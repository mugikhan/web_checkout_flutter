import 'package:api/data/data.dart';
import 'package:api/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:storage/storage.dart';

void main() {
  late MemoryStore clientStore;
  late MemoryStore serverStore;
  late AuthRepository repository;

  AuthRepository build(Link link) => GraphqlAuthRepository(
    client: GraphQLClient(link: link, cache: GraphQLCache()),
    tokens: TokenStore(clientStore),
  );

  setUp(() {
    clientStore = MemoryStore();
    serverStore = MemoryStore();
    repository = GraphqlAuthRepository(
      client: buildGraphqlClient(
        tokens: TokenStore(clientStore),
        server: LocalServer(serverStore),
      ),
      tokens: TokenStore(clientStore),
    );
  });

  test('signIn stores the token and currentViewer reads it back', () async {
    final result = await repository.signIn('  Naledi ');

    expect(result, const SignedIn(Viewer(id: 'viewer:naledi', name: 'Naledi')));
    expect(await clientStore.read('auth.token'), isNotNull);
    expect(
      await repository.currentViewer(),
      const Viewer(id: 'viewer:naledi', name: 'Naledi'),
    );
  });

  test('the server rejects a short name and nothing is stored', () async {
    final result = await repository.signIn('Bob');

    expect(result, const InvalidName(minLength: 4));
    expect(await clientStore.read('auth.token'), isNull);
    expect(await serverStore.read('sessions'), isNull);
  });

  test('currentViewer returns null when no token is stored', () async {
    expect(await repository.currentViewer(), isNull);
  });

  test('currentViewer deletes a token the server does not know', () async {
    await clientStore.write('auth.token', 'stale');

    expect(await repository.currentViewer(), isNull);
    expect(await clientStore.read('auth.token'), isNull);
  });

  test('signOut deletes the token', () async {
    await repository.signIn('Naledi');

    await repository.signOut();

    expect(await clientStore.read('auth.token'), isNull);
    expect(await repository.currentViewer(), isNull);
  });

  test('a GraphQL error maps to SignInUnavailable', () async {
    final broken = build(LocalLink({}));

    expect(await broken.signIn('Naledi'), const SignInUnavailable());
    expect(await clientStore.read('auth.token'), isNull);
  });

  test('a GraphQL error on the viewer query throws ApiFault', () async {
    await clientStore.write('auth.token', 'any');
    final broken = build(LocalLink({}));

    expect(broken.currentViewer(), throwsA(isA<ApiFault>()));
  });
}
