import 'dart:ui';

import 'package:flame/components.dart';

class Background extends Component {
  Background(this.paint);
  final Paint paint;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(20, 20, 10, 10);
    canvas.drawRect(
      rect,
      paint,
    );
  }
}
