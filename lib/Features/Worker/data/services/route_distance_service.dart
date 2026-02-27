import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/worker_job_entity.dart';

/// Fetches road-based distance matrix and route geometry from OSRM for driving.
class RouteDistanceService {
  static const String _osrmBaseUrl = 'https://router.project-osrm.org';
  static const String _tablePath = '/table/v1/driving';
  static const String _routePath = '/route/v1/driving';

  /// Returns distance matrix in meters (road distance) for the given jobs.
  /// Returns null if the request fails (caller can fallback to straight-line).
  static Future<List<List<double>>?> getRoadDistanceMatrix(
    List<WorkerJobEntity> jobs,
  ) async {
    if (jobs.isEmpty) return null;
    if (jobs.length == 1) return [[0.0]];

    final coords = jobs
        .map((j) => '${j.longitude},${j.latitude}')
        .join(';');
    final url = Uri.parse(
      '$_osrmBaseUrl$_tablePath/$coords?annotations=distance',
    );

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Network timeout'),
      );
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] != 'Ok') return null;

      final distances = json['distances'] as List<dynamic>?;
      if (distances == null) return null;

    return distances
        .map((row) => (row as List<dynamic>)
            .map((v) => v != null ? (v as num).toDouble() : double.infinity)
            .toList())
        .toList();
    } catch (_) {
      return null;
    }
  }

  /// Returns road geometry as list of LatLng for the ordered jobs.
  /// Returns null if the request fails (caller uses straight segments).
  static Future<List<LatLng>?> getRoadRouteGeometry(
    List<WorkerJobEntity> orderedJobs,
  ) async {
    if (orderedJobs.length < 2) return null;

    final coords = orderedJobs
        .map((j) => '${j.longitude},${j.latitude}')
        .join(';');
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
}
