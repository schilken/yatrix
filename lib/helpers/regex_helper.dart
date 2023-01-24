class RegexHelper {
  static String? extractIdFromMessage(String message) {
    final exp = RegExp('-> ([a-zA-Z0-9-_]+)');
    final match = exp.firstMatch(message);
    if (match == null) {
      return null;
    }
    final id = match.group(1);
    return id;
  }
}
