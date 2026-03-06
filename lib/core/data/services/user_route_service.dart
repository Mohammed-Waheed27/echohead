import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Fetches road route geometry from OSRM for user-to-bin navigation.
class UserRouteService {
  static const String _osrmBaseUrl = 'https://router.project-osrm.org';
  static const String _routePath = '/route/v1/driving';

  /// Returns road geometry as list of LatLng from origin to destination.
  /// Returns null if the request fails (caller can use straight line).
  static Future<List<LatLng>?> getRouteGeometry(
    LatLng origin,
    LatLng destination,
  ) async {
    final coords = '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}';
    final url = Uri.parse(
      '$_osrmBaseUrl$_routePath/$coords?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Network timeout'),
      );
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] != 'Ok') return null;

      final routes = json['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final geometry = routes[0]['geometry'] as Map<String, dynamic>?;
      if (geometry == null) return null;

      final coordinates = geometry['coordinates'] as List<dynamic>?;
      if (coordinates == null) return null;

      return coordinates
          .map((c) {
            final list = c as List<dynamic>;
            return LatLng(
              (list[1] as num).toDouble(),
              (list[0] as num).toDouble(),
            );
          })
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Haversine distance in meters (straight-line).
  static double straightLineDistanceMeters(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}
