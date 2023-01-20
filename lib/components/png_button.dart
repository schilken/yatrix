import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import '../helpers/game_assets.dart';

class PngButton extends PositionComponent with HasPaint, TapCallbacks {
  late Image _image;
  String name;
  VoidCallback onTap;
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x88ffffff)
    ..strokeWidth = 1.5;

  PngButton({
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
    _image = gameAssets.sprites[name]!.image;
  }

  double get _imageWidth => _image.width.toDouble();
  double get _imageHeight => _image.height.toDouble();
  Vector2 get originalSize => Vector2(_imageWidth, _imageHeight);

  @override
  void render(Canvas canvas) {
    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
    //   _borderPaint,
    // );
    canvas.drawImageRect(_image, originalSize.toRect(), size.toRect(), paint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
