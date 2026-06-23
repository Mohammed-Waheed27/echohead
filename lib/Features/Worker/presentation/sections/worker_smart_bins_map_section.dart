import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/domain/entities/smart_bin_realtime_entity.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_bloc.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_state.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/smart_bin_constants.dart';
import '../../../../core/shared/utils/smart_bin_status_helper.dart';
import '../../../user/presentation/widgets/map_legend_overlay.dart';
import '../../data/worker_satellite_bins_data.dart';
import '../widgets/smart_bin_details_dialog.dart';

class WorkerSmartBinsMapSection extends StatefulWidget {
  const WorkerSmartBinsMapSection({super.key});

  @override
  State<WorkerSmartBinsMapSection> createState() =>
      _WorkerSmartBinsMapSectionState();
}

class _WorkerSmartBinsMapSectionState extends State<WorkerSmartBinsMapSection> {
  GoogleMapController? _mapController;

  static final LatLng _center = SmartBinSatelliteBinsData.center;
  static final CameraPosition _initialPosition = CameraPosition(
    target: _center,
    zoom: 15,
  );

  SmartBinRealtimeEntity _fallbackLiveBin() {
    return const SmartBinRealtimeEntity(
      binId: SmartBinConstants.realtimeBinId,
      buzzer: false,
      distance: 1.58,
      gas: 59,
      gasDanger: false,
      greenLED: true,
      isEmpty: true,
      isFull: false,
      isMedium: false,
      redLED: false,
      yellowLED: false,
    );
  }

  Set<Marker> _buildMarkers(SmartBinRealtimeEntity? liveBin) {
    final liveEntity = liveBin ?? _fallbackLiveBin();
    final markers = <Marker>{
      _buildMarker(
        id: SmartBinConstants.realtimeBinId,
        name: 'حاوية ذكية - مباشر',
        position: _center,
        entity: liveEntity,
        isLive: true,
      ),
    };

    for (final satellite in SmartBinSatelliteBinsData.satelliteBins()) {
      markers.add(
        _buildMarker(
          id: satellite.id,
          name: satellite.name,
          position: satellite.position,
          entity: satellite.data,
          isLive: false,
        ),
      );
    }

    return markers;
  }

  Marker _buildMarker({
    required String id,
    required String name,
    required LatLng position,
    required SmartBinRealtimeEntity entity,
    required bool isLive,
  }) {
    final hue = SmartBinStatusHelper.markerHueFromRealtime(entity);
    final gasPercent = SmartBinStatusHelper.gasPercent(entity.gas);

    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: name,
        snippet:
            '${entity.statusLabel} • غاز $gasPercent%${entity.gasDanger ? ' • خطر' : ''}',
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) =>
              SmartBinDetailsDialog(title: name, bin: entity, isLive: isLive),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartBinRealtimeBloc, SmartBinRealtimeState>(
      builder: (context, state) {
        final liveBin = state is SmartBinRealtimeLoaded
            ? state.bin(SmartBinConstants.realtimeBinId)
            : null;
        final markers = _buildMarkers(liveBin);
        final showGasAlert =
            liveBin?.gasDanger == true || liveBin?.buzzer == true;

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: markers,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              onMapCreated: (controller) => _mapController = controller,
            ),
            const MapLegendOverlay(),
            if (showGasAlert) const _WorkerGasAlertBanner(),
          ],
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

class _WorkerGasAlertBanner extends StatelessWidget {
  const _WorkerGasAlertBanner();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      left: 12.w,
      right: 12.w,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.errorColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.errorColor.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'تنبيه: غاز سام أو جرس طوارئ مفعّل في الحاوية المباشرة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
