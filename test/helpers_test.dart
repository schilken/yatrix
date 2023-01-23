import 'dart:math';

import 'package:test/test.dart';
import 'package:yatrix/helpers/rotation_helper.dart';

void main() {
  group('helpers  - ', () {
    test('indexOfRotationStep rad=0', () {
      final result = RotationHelper.indexOfRotationStep(0);
      expect(result, 0);
    });

    test('indexOfRotationStep rad=-pi/2', () {
      const rad = -pi / 2;
      final result = RotationHelper.indexOfRotationStep(rad);
      expect(result, 3);
    });

    test('indexOfRotationStep rad=-pi/2-pi/2', () {
      const rad = -pi / 2 - pi / 2;
      final result = RotationHelper.indexOfRotationStep(rad);
      expect(result, 2);
    });

    test('indexOfRotationStep rad=-pi/2-pi/2-pi/2', () {
      const rad = -pi / 2 - pi / 2 - pi / 2;
      final result = RotationHelper.indexOfRotationStep(rad);
      expect(result, 1);
    });

    test('indexOfRotationStep rad=-pi/2-pi/2-pi/2-pi/2- pi / 2', () {
      const rad = -pi / 2 - pi / 2 - pi / 2 - pi / 2;
      final result = RotationHelper.indexOfRotationStep(rad);
      expect(result, 0);
    });
  });
}
