import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/rendering.dart';

class SvgButton extends PositionComponent with HasPaint {
  /// The wrapped instance of [Svg].
  late Svg _svg;
  String name;
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x88ffffff);

  SvgButton({
    required this.name,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    Paint? paint,
  }) {
    this.paint = paint ?? this.paint;
    priority = 100;
  }

  Future<void> onLoad() async {
//    debugMode = true;
    _svg = await Svg.load(name);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      _borderPaint,
    );
    _svg.render(canvas, size, overridePaint: paint);
  }

  @override
  void onRemove() {
    super.onRemove();
    _svg.dispose();
  }
}
