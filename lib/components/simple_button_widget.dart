import 'package:flutter/material.dart';

class SimpleButtonWidget extends StatelessWidget {
  const SimpleButtonWidget({
    super.key,
    required this.iconPath,
    required this.onTapped,
  });

  final Path iconPath;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: CustomPaint(
        painter: DemoPainter(iconPath),
        size: const Size.square(40.0),
      ),
    );
  }
}

class DemoPainter extends CustomPainter {
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x50ffffff)
    ..strokeWidth = 1.5;
  final Paint _iconPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xffaaaaaa)
    ..strokeWidth = 7;

  DemoPainter(this.iconPath);
  Path iconPath;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(8),
      ),
      _borderPaint,
    );
    canvas.drawPath(iconPath, _iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BackButtonWidget extends SimpleButtonWidget {
  BackButtonWidget({
    super.key,
    required super.onTapped,
  }) : super(
          iconPath: Path()
            ..moveTo(22, 8)
            ..lineTo(10, 20)
            ..lineTo(22, 32)
            ..moveTo(12, 20)
            ..lineTo(34, 20),
        );
}

class PauseButtonWidget extends SimpleButtonWidget {
  PauseButtonWidget({
    super.key,
    required super.onTapped,
  }) : super(
          iconPath: Path()
            ..moveTo(14, 10)
            ..lineTo(14, 30)
            ..moveTo(26, 10)
            ..lineTo(26, 30),
        );
}
