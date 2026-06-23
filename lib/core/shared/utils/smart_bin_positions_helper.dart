import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SmartBinPositionsHelper {
  SmartBinPositionsHelper._();

  static List<LatLng> satellitePositions({
    required LatLng center,
    required double radiusMeters,
    required int count,
  }) {
    const earthRadius = 6371000.0;
    final results = <LatLng>[];

    for (var i = 0; i < count; i++) {
      final angle = (2 * math.pi * i) / count;
      final dx = radiusMeters * math.cos(angle);
      final dy = radiusMeters * math.sin(angle);
      final latOffset = (dy / earthRadius) * (180 / math.pi);
      final lngOffset =
          (dx / earthRadius) *
          (180 / math.pi) /
          math.cos(center.latitude * math.pi / 180);
      results.add(
        LatLng(center.latitude + latOffset, center.longitude + lngOffset),
      );
    }

    return results;
  }
}
