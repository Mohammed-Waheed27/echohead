import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../domain/entities/worker_job_entity.dart';

class WorkerJobMarkerIcons {
  static BitmapDescriptor? _cleaningIcon;
  static BitmapDescriptor? _fixingIcon;
  static BitmapDescriptor? _completedIcon;

  static Future<void> initialize() async {
    _cleaningIcon ??= await _createColoredMarker(AppColors.primaryGreen);
    _fixingIcon ??= await _createColoredMarker(AppColors.warningColor);
    _completedIcon ??= await _createColoredMarker(AppColors.successColor);
  }

  static BitmapDescriptor getIcon(WorkerJobEntity job) {
    if (job.status == WorkerJobStatus.done) {
      return _completedIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    if (job.type == WorkerJobType.cleaning) {
      return _cleaningIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    return _fixingIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  static Future<BitmapDescriptor> _createColoredMarker(Color color) async {
    const size = 96.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 6;

    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}
