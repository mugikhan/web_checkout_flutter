import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

import 'request_context.dart';

/// Resolver answers one operation with its JSON data.
typedef Resolver = Future<Map<String, dynamic>> Function(
  Map<String, dynamic> variables,
  RequestContext context,
);

/// StreamResolver answers one subscription with a stream of JSON data.
typedef StreamResolver = Stream<Map<String, dynamic>> Function(
  Map<String, dynamic> variables,
  RequestContext context,
);

/// LocalLink routes each request by operation name to an in-app resolver.
class LocalLink extends Link {
  LocalLink(this._resolvers, {this._streams = const {}});

  final Map<String, Resolver> _resolvers;
  final Map<String, StreamResolver> _streams;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final name = _operationName(request.operation);
    final stream = _streams[name];
    if (stream != null) {
      try {
        await for (final data in stream(
          request.variables,
          RequestContext.fromRequest(request),
        )) {
          yield Response(data: data, response: {'data': data});
        }
      } on Object catch (error) {
        yield _error('Resolver for "$name" failed: $error');
      }
      return;
    }
    final resolver = _resolvers[name];
    if (resolver == null) {
      yield _error('No resolver for operation "$name".');
      return;
    }
    try {
      final data = await resolver(
        request.variables,
        RequestContext.fromRequest(request),
      );
      yield Response(data: data, response: {'data': data});
    } on Object catch (error) {
      yield _error('Resolver for "$name" failed: $error');
    }
  }

  // The generated options leave operationName null, so fall back to the document.
  static String? _operationName(Operation operation) =>
      operation.operationName ??
      operation.document.definitions
          .whereType<OperationDefinitionNode>()
          .firstOrNull
          ?.name
          ?.value;

  static Response _error(String message) => Response(
    errors: [GraphQLError(message: message)],
    response: {
      'errors': [
        {'message': message},
      ],
    },
  );
}
