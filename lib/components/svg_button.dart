import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/rendering.dart';

class SvgButton extends PositionComponent with HasPaint, TapCallbacks {
  /// The wrapped instance of [Svg].
  late Svg _svg;
  String name;
  VoidCallback onTap;
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x50ffffff)
    ..strokeWidth = 1.5;


  SvgButton({
    required this.name,
    required this.onTap,
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

  @override
  Future<void> onLoad() async {
//    debugMode = true;
    _svg = await Svg.load(name);
//    paint = Paint()..color = const Color(0x80ffffff);
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
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  void onRemove() {
    super.onRemove();
    _svg.dispose();
  }
}
