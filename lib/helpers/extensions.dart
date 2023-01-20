import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

extension DoubleExt on double {
  Vector2 angleToVector2(double radius) =>
      Vector2(sin(this), cos(this)) * radius;
}

extension Rad2Deg on double {
  String get toStringAsDegrees {
    return (this / pi * 180).toStringAsFixed(1);
  }

  double get degAsRadian => this / 180 * pi;
}

extension WorldUtils on CameraComponent {
  Vector2 screenToWorld(Vector2 screenPosition) {
//    print('position: ${viewfinder.position}, zoom: ${viewfinder.zoom}');
    return (screenPosition - viewport.size / 2) / viewfinder.zoom -
        viewfinder.position;
  }
}

extension WorldUtils2 on CameraComponent {
  Vector2 toWorld(Vector2 viewfinderPosition) {
    return (viewfinderPosition - Vector2(viewport.size.x / 2, 0)) /
            viewfinder.zoom +
        viewfinder.position;
  }
}

extension TimesOnIntExtension on int {
  void times(void Function(int) fun) =>
      Iterable<int>.generate(this).forEach(fun);
}
