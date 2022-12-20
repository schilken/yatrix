import 'dart:math';

import 'package:flame/components.dart';

class Helpers {
  static int roundedDegreeFromRadian(double rad) {
    return radianToDegree(rad).round();
  }

  static int indexOfRotationStep(double rad) {
    return (roundedDegreeFromRadian(rad) ~/ 90) % 4;
  }

  static Vector2 rotCorrection(double rad) {
    switch (indexOfRotationStep(rad)) {
      case 3:
        return Vector2(0.0, -1.0);
      case 2:
        return Vector2(-1.0, -1.0);
      case 1:
        return Vector2(-1.0, 0.0);
      default:
        return Vector2(0.0, 0.0);
    }
  }

  static double degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  static double radianToDegree(double radian) {
    return radian * 180 / pi;
  }
}
