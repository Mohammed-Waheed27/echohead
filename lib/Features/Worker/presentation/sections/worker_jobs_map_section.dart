import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../bloc/worker_job_bloc.dart';
import '../widgets/worker_job_info_dialog.dart';
import '../widgets/worker_jobs_map_legend.dart';

class WorkerJobsMapSection extends StatefulWidget {
  const WorkerJobsMapSection({super.key});

  @override
  State<WorkerJobsMapSection> createState() => _WorkerJobsMapSectionState();
}

class _WorkerJobsMapSectionState extends State<WorkerJobsMapSection> {
  GoogleMapController? _mapController;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
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
      double hue;
      if (job.status == WorkerJobStatus.done) {
        hue = BitmapDescriptor.hueAzure;
      } else if (job.type == WorkerJobType.cleaning) {
        hue = BitmapDescriptor.hueGreen;
      } else {
        hue = BitmapDescriptor.hueOrange;
      }
      return Marker(
        markerId: MarkerId(job.id),
        position: LatLng(job.latitude, job.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: job.title,
          snippet: job.type == WorkerJobType.cleaning ? 'تنظيف' : 'صيانة',
        ),
        onTap: () => onTap(job),
      );
    }).toSet();
  }

  Set<Polyline> _buildRoutePolylines(
    List<WorkerJobEntity>? orderedJobs,
  ) {
    if (orderedJobs == null || orderedJobs.length < 2) return {};
    final points = orderedJobs
        .map((j) => LatLng(j.latitude, j.longitude))
        .toList();
    return {
      Polyline(
        polylineId: const PolylineId('optimized_route'),
        points: points,
        color: AppColors.primaryGreen,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerJobBloc, WorkerJobState>(
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
        final loadedState = state as WorkerJobLoaded;
        final markers = _buildMarkers(loadedState.jobs, (job) {
          showDialog(
            context: context,
            builder: (ctx) => BlocProvider.value(
              value: context.read<WorkerJobBloc>(),
              child: WorkerJobInfoDialog(job: job),
            ),
          );
        });
        final polylines = _buildRoutePolylines(loadedState.optimizedRouteOrder);

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
                  onMapCreated: (controller) => _mapController = controller,
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
