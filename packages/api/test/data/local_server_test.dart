import 'package:api/data/data.dart';
import 'package:api/src/data/graphql/auth.graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  late MemoryStore store;
  late LocalServer server;

  setUp(() {
    store = MemoryStore();
    server = LocalServer(store);
  });

  Future<Mutation$SignIn> signIn(String name) async => Mutation$SignIn.fromJson(
    await server.resolvers['SignIn']!({'name': name}, const RequestContext()),
  );

  Future<Query$Viewer> viewer({String? token}) async => Query$Viewer.fromJson(
    await server.resolvers['Viewer']!({}, RequestContext(token: token)),
  );

  test('signIn with a valid name returns a viewer and a token', () async {
    final result = await signIn('Naledi');

    final success = result.signIn as Mutation$SignIn$signIn$$SignInSuccess;
    expect(success.viewer.name, 'Naledi');
    expect(success.viewer.id, 'viewer:naledi');
    expect(success.token, hasLength(64));
  });

  test('signIn trims the name', () async {
    final result = await signIn('  Naledi  ');

    final success = result.signIn as Mutation$SignIn$signIn$$SignInSuccess;
    expect(success.viewer.name, 'Naledi');
  });

  for (final name in ['Bob', '  Bob  ', '    ', '']) {
    test('signIn rejects "$name" and stores no session', () async {
      final result = await signIn(name);

      final invalid = result.signIn as Mutation$SignIn$signIn$$InvalidName;
      expect(invalid.minLength, 4);
      expect(await store.read('sessions'), isNull);
    });
  }

  test('viewer returns the viewer for a known token', () async {
    final success =
        (await signIn('Naledi')).signIn
            as Mutation$SignIn$signIn$$SignInSuccess;

    final result = await viewer(token: success.token);

    expect(result.viewer?.name, 'Naledi');
  });

  test('viewer returns null without a token or with an unknown one', () async {
    await signIn('Naledi');

    expect((await viewer()).viewer, isNull);
    expect((await viewer(token: 'unknown')).viewer, isNull);
  });

  test('sessions survive a new server over the same store', () async {
    final success =
        (await signIn('Naledi')).signIn
            as Mutation$SignIn$signIn$$SignInSuccess;

    final restarted = LocalServer(store);
    final result = Query$Viewer.fromJson(
      await restarted.resolvers['Viewer']!(
        {},
        RequestContext(token: success.token),
      ),
    );

    expect(result.viewer?.name, 'Naledi');
  });
}
