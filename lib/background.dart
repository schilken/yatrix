import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Background extends Component {
  Background(this.color);
  final Color color;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, 50, 50);
    canvas.drawRect(
      rect,
      BasicPalette.black.paint(),
    );
  }
}
