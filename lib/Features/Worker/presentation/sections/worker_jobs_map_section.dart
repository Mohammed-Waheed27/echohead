import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../bloc/worker_job_bloc.dart';
import '../utils/worker_job_marker_icons.dart';
import '../widgets/worker_job_info_dialog.dart';
import '../widgets/worker_jobs_map_legend.dart';

class WorkerJobsMapSection extends StatefulWidget {
  const WorkerJobsMapSection({super.key});

  @override
  State<WorkerJobsMapSection> createState() => _WorkerJobsMapSectionState();
}

class _WorkerJobsMapSectionState extends State<WorkerJobsMapSection> {
  GoogleMapController? _mapController;
  bool _markerIconsReady = false;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _requestLocationPermission();
      await WorkerJobMarkerIcons.initialize();
      if (mounted) setState(() => _markerIconsReady = true);
    });
  }

  Future<void> _requestLocationPermission() async {
    if (!mounted) return;
    await LocationPermissionHandler.requestLocationPermission(context);
  }

  Set<Marker> _buildMarkers(
    List<WorkerJobEntity> jobs,
    void Function(WorkerJobEntity) onTap,
  ) {
    return jobs.map((job) {
      final snippet = job.status == WorkerJobStatus.done
          ? 'مكتملة'
          : job.type == WorkerJobType.cleaning
              ? 'تنظيف'
              : 'صيانة';
      return Marker(
        markerId: MarkerId(job.id),
        position: LatLng(job.latitude, job.longitude),
        icon: WorkerJobMarkerIcons.getIcon(job),
        infoWindow: InfoWindow(title: job.title, snippet: snippet),
        onTap: () => onTap(job),
      );
    }).toSet();
  }

  Set<Polyline> _buildRoutePolylines(
    List<WorkerJobEntity>? orderedJobs,
    List<LatLng>? routePolylinePoints,
  ) {
    List<LatLng> points;
    if (routePolylinePoints != null && routePolylinePoints.length >= 2) {
      points = routePolylinePoints;
    } else if (orderedJobs != null && orderedJobs.length >= 2) {
      points = orderedJobs
          .map((j) => LatLng(j.latitude, j.longitude))
          .toList();
    } else {
      return {};
    }
    return {
      Polyline(
        polylineId: const PolylineId('optimized_route'),
        points: points,
        color: AppColors.accentTeal,
        width: 6,
      ),
    };
  }

  void _fitRouteBounds(
    List<LatLng> points,
    GoogleMapController controller,
  ) {
    if (points.length < 2) return;
    double minLat = points.first.latitude;
    double maxLat = minLat;
    double minLng = points.first.longitude;
    double maxLng = minLng;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerJobBloc, WorkerJobState>(
      listener: (context, state) {
        if (state is WorkerJobLoaded && _mapController != null) {
          final points = state.routePolylinePoints ??
              state.optimizedRouteOrder
                  ?.map((j) => LatLng(j.latitude, j.longitude))
                  .toList();
          if (points != null && points.length >= 2) {
            _fitRouteBounds(points, _mapController!);
          }
        }
      },
      builder: (context, state) {
        if (state is WorkerJobLoading) {
          return Container(
            height: 300.h,
            color: AppColors.surfaceColor,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
          );
        }
        if (state is WorkerJobError) {
          return Container(
            height: 200.h,
            padding: EdgeInsets.all(24.w),
            color: AppColors.surfaceColor,
            child: Center(
              child: Text(
                state.message,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          );
        }
        if (state is! WorkerJobLoaded) {
          return const SizedBox.shrink();
        }
        final loadedState = state;
        final markers = _buildMarkers(loadedState.jobs, (job) {
          showDialog(
            context: context,
            builder: (ctx) => BlocProvider.value(
              value: context.read<WorkerJobBloc>(),
              child: WorkerJobInfoDialog(job: job),
            ),
          );
        });
        final polylines = _buildRoutePolylines(
          loadedState.optimizedRouteOrder,
          loadedState.routePolylinePoints,
        );

        return Container(
          height: 400.h,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: markers,
                  polylines: polylines,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (controller) {
                    _mapController = controller;
                    final st = context.read<WorkerJobBloc>().state;
                    if (st is WorkerJobLoaded) {
                      final pts = st.routePolylinePoints ??
                          st.optimizedRouteOrder
                              ?.map((j) => LatLng(j.latitude, j.longitude))
                              .toList();
                      if (pts != null && pts.length >= 2) {
                        _fitRouteBounds(pts, controller);
                      }
                    }
                  },
                ),
                const WorkerJobsMapLegend(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
