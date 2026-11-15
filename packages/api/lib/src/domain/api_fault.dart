/// ApiFault reports an unexpected data-layer fault, such as a GraphQL error.
class ApiFault implements Exception {
  const ApiFault(this.message);

  final String message;

  @override
  String toString() => 'ApiFault: $message';
}
