import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

class LevelIndicator extends PositionComponent with TapCallbacks {
  LevelIndicator({
    required this.level,
    required this.color,
    this.onTapped,
    super.position,
  }) {
    _iconPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
  }

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xaaffffff);
  late Paint _iconPaint;

  int level;
  final Color color;
  final VoidCallback? onTapped;

  @override
  void render(Canvas canvas) {
    final frame = Rect.fromPoints(
      Offset(0, size.y),
      Offset(size.x, 0),
    );
    final rect = Rect.fromPoints(
      Offset(0, size.y),
      Offset(size.x, (20 - level) / 20 * size.y),
    );
    canvas.drawRect(rect, _iconPaint);
    canvas.drawRect(frame, _borderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
//    _iconPaint.color = const Color(0xffffffff);
  }

  @override
  void onTapUp(TapUpEvent event) {
//    _iconPaint.color = const Color(0xffaaaaaa);
    onTapped?.call();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);
  }
}
