import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/app_colors.dart';

class LiquidGlassGradientDecoration extends Decoration {
  final bool hasWavyBottom;
  final double wavyDepth;
  final List<Color>? customColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final BorderRadius? borderRadius;

  const LiquidGlassGradientDecoration({
    this.hasWavyBottom = false,
    this.wavyDepth = 20.0,
    this.customColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LiquidGlassPainter(
      this,
      onChanged,
    );
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is LiquidGlassGradientDecoration) {
      return LiquidGlassGradientDecoration(
        hasWavyBottom: hasWavyBottom,
        wavyDepth: ui.lerpDouble(a.wavyDepth, wavyDepth, t) ?? wavyDepth,
        customColors: customColors,
        begin: begin,
        end: end,
        borderRadius: borderRadius,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is LiquidGlassGradientDecoration) {
      return LiquidGlassGradientDecoration(
        hasWavyBottom: hasWavyBottom,
        wavyDepth: ui.lerpDouble(wavyDepth, b.wavyDepth, t) ?? wavyDepth,
        customColors: customColors ?? b.customColors,
        begin: begin,
        end: end,
        borderRadius: borderRadius,
      );
    }
    return super.lerpTo(b, t);
  }
}

class _LiquidGlassPainter extends BoxPainter {
  final LiquidGlassGradientDecoration decoration;

  _LiquidGlassPainter(
    this.decoration,
    super.onChanged,
  );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final colors = decoration.customColors ?? AppColors.liquidGlassGradient;

    // Create main gradient
    final mainGradient = LinearGradient(
      begin: decoration.begin,
      end: decoration.end,
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
    );

    // Draw main gradient background
    final mainPaint = Paint()
      ..shader = mainGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    if (decoration.hasWavyBottom) {
      // Create wavy path
      final path = _createWavyPath(rect, decoration.wavyDepth);
      canvas.drawPath(path, mainPaint);
    } else {
      // Draw regular rounded rectangle
      final borderRadius = decoration.borderRadius ?? BorderRadius.zero;
      final rrect = borderRadius.toRRect(rect);
      canvas.drawRRect(rrect, mainPaint);
    }

    // Add liquid glass overlay layers for depth
    _drawLiquidGlassLayers(canvas, rect, colors);
  }

  Path _createWavyPath(Rect rect, double depth) {
    final path = Path();
    final waveHeight = depth;
    final borderRadius = decoration.borderRadius ?? BorderRadius.zero;

    path.moveTo(rect.left, rect.top);

    // Handle top corners
    final topLeft = borderRadius.topLeft;
    if (topLeft.x > 0 || topLeft.y > 0) {
      path.arcToPoint(
        Offset(rect.left + topLeft.x, rect.top + topLeft.y),
        radius: topLeft,
        clockwise: false,
      );
    } else {
      path.lineTo(rect.left, rect.top);
    }

    path.lineTo(rect.right - borderRadius.topRight.x, rect.top);

    final topRight = borderRadius.topRight;
    if (topRight.x > 0 || topRight.y > 0) {
      path.arcToPoint(
        Offset(rect.right, rect.top + topRight.y),
        radius: topRight,
        clockwise: false,
      );
    }

    // Wavy bottom edge
    path.lineTo(rect.right, rect.bottom - waveHeight);

    final numberOfWaves = 3;
    final waveWidth = rect.width / numberOfWaves;

    for (int i = 0; i <= numberOfWaves; i++) {
      final x = rect.right - (i * waveWidth);
      final y = rect.bottom -
          waveHeight +
          (waveHeight / 2) *
              (1 +
                  (i % 2 == 0 ? 1 : -1) *
                      (i < numberOfWaves ? 1 : 0));
      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.quadraticBezierTo(
          x + waveWidth / 2,
          rect.bottom - waveHeight + (i % 2 == 0 ? waveHeight : 0),
          x,
          y,
        );
      }
    }

    path.lineTo(rect.left, rect.bottom - waveHeight);

    // Handle bottom left corner
    final bottomLeft = borderRadius.bottomLeft;
    if (bottomLeft.x > 0 || bottomLeft.y > 0) {
      path.arcToPoint(
        Offset(rect.left, rect.bottom - bottomLeft.y),
        radius: bottomLeft,
        clockwise: false,
      );
    }

    path.close();
    return path;
  }

  void _drawLiquidGlassLayers(Canvas canvas, Rect rect, List<Color> colors) {
    // Add organic curved shapes for liquid glass effect
    final overlayPaint1 = Paint()
      ..color = colors[0].withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final overlayPaint2 = Paint()
      ..color = colors[1].withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Create organic curved shapes
    final path1 = Path()
      ..moveTo(rect.left, rect.top)
      ..quadraticBezierTo(
        rect.left + rect.width * 0.3,
        rect.top + rect.height * 0.2,
        rect.left + rect.width * 0.6,
        rect.top + rect.height * 0.1,
      )
      ..quadraticBezierTo(
        rect.left + rect.width * 0.8,
        rect.top + rect.height * 0.15,
        rect.right,
        rect.top,
      )
      ..lineTo(rect.right, rect.top + rect.height * 0.3)
      ..quadraticBezierTo(
        rect.left + rect.width * 0.7,
        rect.top + rect.height * 0.25,
        rect.left + rect.width * 0.4,
        rect.top + rect.height * 0.3,
      )
      ..quadraticBezierTo(
        rect.left + rect.width * 0.1,
        rect.top + rect.height * 0.25,
        rect.left,
        rect.top + rect.height * 0.2,
      )
      ..close();

    final path2 = Path()
      ..moveTo(rect.right, rect.bottom)
      ..quadraticBezierTo(
        rect.right - rect.width * 0.2,
        rect.bottom - rect.height * 0.3,
        rect.right - rect.width * 0.5,
        rect.bottom - rect.height * 0.25,
      )
      ..quadraticBezierTo(
        rect.right - rect.width * 0.8,
        rect.bottom - rect.height * 0.3,
        rect.left,
        rect.bottom - rect.height * 0.2,
      )
      ..lineTo(rect.left, rect.bottom)
      ..close();

    canvas.drawPath(path1, overlayPaint1);
    canvas.drawPath(path2, overlayPaint2);
  }
}
