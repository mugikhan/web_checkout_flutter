/// ViewerName holds the client-side rule for a sign-in name.
abstract final class ViewerName {
  static const minLength = 4;

  static bool isValid(String name) => name.trim().length >= minLength;
}
