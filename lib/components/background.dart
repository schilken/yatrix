import 'dart:ui';

import 'package:flame/components.dart';

class Background extends Component {
  Background({
    required this.paint,
    this.rect,
  });
  final Paint paint;
  final Rect? rect;
  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      rect ?? const Rect.fromLTWH(20, 20, 10, 10),
      paint,
    );
  }
}
