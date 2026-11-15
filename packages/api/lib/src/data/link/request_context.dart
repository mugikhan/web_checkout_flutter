import 'package:graphql/client.dart';

/// RequestContext carries what a resolver may know about the caller.
class RequestContext {
  const RequestContext({this.token});

  /// RequestContext.fromRequest reads the bearer token, as a server reads headers.
  factory RequestContext.fromRequest(Request request) {
    final header = request.context
        .entry<HttpLinkHeaders>()
        ?.headers['Authorization'];
    const scheme = 'Bearer ';
    return RequestContext(
      token: header != null && header.startsWith(scheme)
          ? header.substring(scheme.length)
          : null,
    );
  }

  final String? token;
}
