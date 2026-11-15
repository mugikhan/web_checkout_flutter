import 'dart:io';

import 'package:api/data/data.dart';
import 'package:api/src/data/graphql/auth.graphql.dart';
import 'package:api/src/data/graphql/orders.graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/ast.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:storage/storage.dart';

void main() {
  Request request(DocumentNode document, {String? authorization}) {
    final base = Request(operation: Operation(document: document));
    if (authorization == null) return base;
    return base.withContextEntry(
      HttpLinkHeaders(headers: {'Authorization': authorization}),
    );
  }

  test('routes a request by operation name', () async {
    final link = LocalLink({
      'Viewer': (variables, context) async => {
        'viewer': null,
        '__typename': 'Query',
      },
    });

    final response = await link.request(request(documentNodeQueryViewer)).first;

    expect(response.errors, isNull);
    expect(response.data, {'viewer': null, '__typename': 'Query'});
  });

  test('passes the bearer token to the resolver context', () async {
    String? seen;
    final link = LocalLink({
      'Viewer': (variables, context) async {
        seen = context.token;
        return {'viewer': null, '__typename': 'Query'};
      },
    });

    await link
        .request(request(documentNodeQueryViewer, authorization: 'Bearer abc'))
        .first;

    expect(seen, 'abc');
  });

  test('answers an unknown operation with a GraphQL error', () async {
    final link = LocalLink({});

    final response = await link.request(request(documentNodeQueryViewer)).first;

    expect(response.data, isNull);
    expect(response.errors?.single.message, contains('"Viewer"'));
  });

  test('turns a resolver exception into a GraphQL error', () async {
    final link = LocalLink({
      'Viewer': (variables, context) async => throw StateError('boom'),
    });

    final response = await link.request(request(documentNodeQueryViewer)).first;

    expect(response.errors?.single.message, contains('boom'));
  });

  test('yields every event a stream resolver emits, then closes', () async {
    final link = LocalLink(
      {},
      streams: {
        'OrderStatusChanged': (variables, context) async* {
          yield {'orderStatusChanged': 'first'};
          yield {'orderStatusChanged': 'second'};
        },
      },
    );

    final responses = await link
        .request(request(documentNodeSubscriptionOrderStatusChanged))
        .toList();

    expect(responses.map((r) => r.data), [
      {'orderStatusChanged': 'first'},
      {'orderStatusChanged': 'second'},
    ]);
  });

  test('turns a stream resolver exception into a GraphQL error', () async {
    final link = LocalLink(
      {},
      streams: {
        'OrderStatusChanged': (variables, context) async* {
          yield {'orderStatusChanged': 'first'};
          throw StateError('boom');
        },
      },
    );

    final responses = await link
        .request(request(documentNodeSubscriptionOrderStatusChanged))
        .toList();

    expect(responses, hasLength(2));
    expect(responses.last.errors?.single.message, contains('boom'));
  });

  test('every operation in the .graphql files has a resolver', () {
    final names = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.graphql'))
        .expand(
          (f) =>
              parseString(f.readAsStringSync()).definitions
                  .whereType<OperationDefinitionNode>(),
        )
        .map((operation) => operation.name!.value)
        .toSet();

    expect(names, isNotEmpty);
    final server = LocalServer(MemoryStore());
    expect({...server.resolvers.keys, ...server.streams.keys}, names);
  });
}
