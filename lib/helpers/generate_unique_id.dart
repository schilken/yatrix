import 'dart:math';

String generateUniqueId() {
  final _random = Random.secure();
  const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_';
  return List.generate(7, (index) => _chars[_random.nextInt(_chars.length)])
      .join();
}
