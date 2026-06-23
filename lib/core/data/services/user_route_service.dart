import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Fetches road route geometry from OSRM for user-to-bin navigation.
class UserRouteService {
  static const String _osrmBaseUrl = 'https://router.project-osrm.org';
  static const List<String> _streetProfiles = ['walking', 'driving'];

  /// Returns street-following geometry from origin to destination.
  /// Tries walking first, then driving. Returns null if routing fails.
  static Future<List<LatLng>?> getStreetRouteGeometry(
    LatLng origin,
    LatLng destination,
  ) async {
    for (final profile in _streetProfiles) {
      final route = await _fetchRouteGeometry(
        profile: profile,
        origin: origin,
        destination: destination,
      );
      if (route != null && route.length >= 2) {
        return route;
      }
    }
    return null;
  }

  /// Backward-compatible alias used elsewhere in the app.
  static Future<List<LatLng>?> getRouteGeometry(
    LatLng origin,
    LatLng destination,
  ) {
    return getStreetRouteGeometry(origin, destination);
  }

  static Future<List<LatLng>?> _fetchRouteGeometry({
    required String profile,
    required LatLng origin,
    required LatLng destination,
  }) async {
    final coords =
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}';
    final url = Uri.parse(
      '$_osrmBaseUrl/route/v1/$profile/$coords'
      '?overview=full&geometries=geojson&steps=false',
    );

    try {
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 20),
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
      if (coordinates == null || coordinates.length < 2) return null;

      return coordinates.map((c) {
        final list = c as List<dynamic>;
        return LatLng((list[1] as num).toDouble(), (list[0] as num).toDouble());
      }).toList();
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
