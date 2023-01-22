import 'dart:math';

/// first and last character must be alphanumeric,
/// - and _ are allowed in the middle
String generateUniqueId() {
  final _random = Random.secure();
  const _alphanumeric =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const _chars = '$_alphanumeric-_';
  final firstChar = _alphanumeric[_random.nextInt(_alphanumeric.length)];
  final lastChar = _alphanumeric[_random.nextInt(_alphanumeric.length)];
  return firstChar +
      List.generate(5, (index) => _chars[_random.nextInt(_chars.length)])
          .join() +
      lastChar;
}
