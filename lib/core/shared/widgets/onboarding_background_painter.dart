import 'package:flutter/material.dart';

/// CustomPainter that recreates the onboarding welcome background:
/// - Linear gradient (light green top-left to darker green bottom-right)
/// - Organic blob and wave shapes in darker green for depth
class OnboardingBackgroundPainter extends CustomPainter {
  /// Lighter green at top-left of the main gradient
  static const Color _gradientTopLeft = Color(0xFF55E03C); // RGB: 85, 224, 60

  /// Darker green at bottom-right of the main gradient
  static const Color _gradientBottomRight = Color(0xFF399A21); // RGB: 57, 154, 33

  /// Solid fill for overlay shapes (blobs and waves)
  static const Color _shapeGreen = Color(0xFF3D9C28); // RGB: 61, 156, 40

  /// Darker green for radial gradient edge (top-right blob)
  static const Color _shapeGreenDark = Color(0xFF2C7A1D); // RGB: 44, 122, 29

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    _drawBackgroundGradient(canvas, rect);
    _drawShapeA_TopLeftBlob(canvas, size);
    _drawShapeB_MidLeftWave(canvas, size);
    _drawShapeC_TopRightBlob(canvas, size);
    _drawShapeD_BottomRightWave(canvas, size);
  }

  void _drawBackgroundGradient(Canvas canvas, Rect rect) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [_gradientTopLeft, _gradientBottomRight],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRect(rect, paint);
  }

  /// Top-left amorphous blob
  void _drawShapeA_TopLeftBlob(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.0, h * 0.08)
      ..cubicTo(
        w * 0.12, h * 0.02,
        w * 0.28, h * 0.06,
        w * 0.38, h * 0.14,
      )
      ..cubicTo(
        w * 0.45, h * 0.22,
        w * 0.35, h * 0.32,
        w * 0.22, h * 0.28,
      )
      ..cubicTo(
        w * 0.08, h * 0.24,
        w * 0.0, h * 0.18,
        w * 0.0, h * 0.08,
      )
      ..close();

    final paint = Paint()
      ..color = _shapeGreen
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  /// Mid-left S-curve wave from left edge
  void _drawShapeB_MidLeftWave(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.0, h * 0.42)
      ..cubicTo(
        w * 0.08, h * 0.38,
        w * 0.22, h * 0.48,
        w * 0.32, h * 0.44,
      )
      ..cubicTo(
        w * 0.42, h * 0.40,
        w * 0.38, h * 0.52,
        w * 0.28, h * 0.58,
      )
      ..cubicTo(
        w * 0.14, h * 0.64,
        w * 0.02, h * 0.56,
        w * 0.0, h * 0.50,
      )
      ..lineTo(w * 0.0, h * 0.42)
      ..close();

    final paint = Paint()
      ..color = _shapeGreen
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  /// Top-right large rounded blob with radial gradient
  void _drawShapeC_TopRightBlob(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w * 0.78;
    final centerY = h * 0.22;
    final radius = w * 0.35;

    final path = Path()
      ..moveTo(centerX + radius * 0.95, centerY)
      ..cubicTo(
        centerX + radius * 0.95, centerY - radius * 0.6,
        centerX + radius * 0.5, centerY - radius * 0.95,
        centerX, centerY - radius * 0.95,
      )
      ..cubicTo(
        centerX - radius * 0.5, centerY - radius * 0.95,
        centerX - radius * 0.95, centerY - radius * 0.5,
        centerX - radius * 0.95, centerY,
      )
      ..cubicTo(
        centerX - radius * 0.95, centerY + radius * 0.5,
        centerX - radius * 0.5, centerY + radius * 0.95,
        centerX, centerY + radius * 0.95,
      )
      ..cubicTo(
        centerX + radius * 0.5, centerY + radius * 0.95,
        centerX + radius * 0.95, centerY + radius * 0.5,
        centerX + radius * 0.95, centerY,
      )
      ..close();

    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: const [_shapeGreen, _shapeGreenDark],
    );
    final rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  /// Bottom-right elongated wave
  void _drawShapeD_BottomRightWave(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 1.0, h * 0.92)
      ..cubicTo(
        w * 0.88, h * 0.88,
        w * 0.78, h * 0.94,
        w * 0.68, h * 0.88,
      )
      ..cubicTo(
        w * 0.58, h * 0.82,
        w * 0.52, h * 0.92,
        w * 0.42, h * 0.96,
      )
      ..cubicTo(
        w * 0.28, h * 1.0,
        w * 0.18, h * 0.94,
        w * 0.12, h * 0.98,
      )
      ..lineTo(w * 0.05, h * 1.0)
      ..lineTo(w * 1.0, h * 1.0)
      ..lineTo(w * 1.0, h * 0.92)
      ..close();

    final paint = Paint()
      ..color = _shapeGreen
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
