import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_can/core/presentation/bloc/bin_event.dart';
import '../../../../core/domain/entities/bin_entity.dart';
import '../../../../core/domain/entities/smart_bin_realtime_entity.dart';
import '../../../../core/presentation/bloc/bin_bloc.dart';
import '../../../../core/presentation/bloc/bin_state.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_bloc.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_state.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/smart_bin_constants.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../../../../core/shared/utils/smart_bin_status_helper.dart';
import '../../../../core/data/smart_bin_satellite_bins_data.dart';
import '../../../../core/data/services/user_route_service.dart';
import '../widgets/map_legend_overlay.dart';

/// Map centered on the live smart bin with bins, RTDB status, and route to nearest ready bin.
class UserHomeMapSection extends StatefulWidget {
  final VoidCallback? onMapInteraction;
  final ValueNotifier<int>? findNearestTrigger;

  const UserHomeMapSection({
    super.key,
    this.onMapInteraction,
    this.findNearestTrigger,
  });

  @override
  State<UserHomeMapSection> createState() => _UserHomeMapSectionState();
}

class _UserHomeMapSectionState extends State<UserHomeMapSection> {
  GoogleMapController? _mapController;
  bool _hasError = false;
  bool _locationPermissionGranted = false;
  Position? _currentPosition;
  Set<Polyline> _polylines = {};

  static final LatLng _mapCenter = LatLng(
    SmartBinConstants.workerRealtimeBinLat,
    SmartBinConstants.workerRealtimeBinLng,
  );
  static final CameraPosition _initialPosition = CameraPosition(
    target: _mapCenter,
    zoom: 15,
  );

  static final Map<String, SmartBinSatelliteBinItem> _satelliteByUserBinId =
      SmartBinSatelliteBinsData.byUserHomeBinId();

  Set<Marker> _buildMarkers({
    required List<BinEntity> bins,
    required SmartBinRealtimeEntity? liveMiddleBin,
  }) {
    return bins.map((bin) {
      final isLiveBin = bin.id == SmartBinConstants.userHomeLinkedBinId;
      final satellite = _satelliteByUserBinId[bin.id];
      final hue = isLiveBin && liveMiddleBin != null
          ? SmartBinStatusHelper.markerHueFromRealtime(liveMiddleBin)
          : satellite != null
          ? SmartBinStatusHelper.markerHueFromRealtime(satellite.data)
          : SmartBinStatusHelper.markerHueFromFillPercent(bin.fillPercent);

      final snippet = isLiveBin && liveMiddleBin != null
          ? 'الحالة: ${liveMiddleBin.statusLabel} • غاز ${liveMiddleBin.gasPercent()}%'
          : satellite != null
          ? 'الحالة: ${satellite.data.statusLabel} • غاز ${SmartBinStatusHelper.gasPercent(satellite.data.gas)}%'
          : 'ممتلئة بنسبة ${bin.fillPercent}%';

      return Marker(
        markerId: MarkerId(bin.id),
        position: LatLng(bin.latitude, bin.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(title: bin.name, snippet: snippet),
      );
    }).toSet();
  }

  bool _isBinReady({
    required BinEntity bin,
    required SmartBinRealtimeEntity? liveMiddleBin,
  }) {
    if (bin.isUnderMaintenance) return false;
    if (bin.id == SmartBinConstants.userHomeLinkedBinId &&
        liveMiddleBin != null) {
      return liveMiddleBin.isReady;
    }
    final satellite = _satelliteByUserBinId[bin.id];
    if (satellite != null) return satellite.data.isReady;
    return bin.fillPercent < 50;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartBinRealtimeBloc, SmartBinRealtimeState>(
      builder: (context, realtimeState) {
        final liveMiddleBin = realtimeState is SmartBinRealtimeLoaded
            ? realtimeState.bin(SmartBinConstants.realtimeBinId)
            : null;

        return BlocBuilder<BinBloc, BinState>(
          builder: (context, state) {
            if (state is BinLoading || state is BinInitial) {
              return _buildLoadingWidget();
            }
            if (state is BinError) {
              return _buildErrorStateWidget(state.message);
            }
            final bins = (state as BinLoaded).bins;
            final markers = _buildMarkers(
              bins: bins,
              liveMiddleBin: liveMiddleBin,
            );
            return _buildMapContainer(markers);
          },
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );
  }

  Widget _buildErrorStateWidget(String message) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Center(
        child: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: AppColors.errorColor, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildMapContainer(Set<Marker> markers) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        child: _hasError
            ? _buildErrorWidget(markers)
            : _buildMapWidget(markers),
      ),
    );
  }

  Widget _buildMapWidget(Set<Marker> markers) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: markers,
          polylines: _polylines,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: _locationPermissionGranted,
          myLocationEnabled: _locationPermissionGranted,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            if (mounted) setState(() => _hasError = false);
          },
          mapToolbarEnabled: false,
          onCameraMoveStarted: () => widget.onMapInteraction?.call(),
        ),
        const MapLegendOverlay(),
      ],
    );
  }

  Widget _buildErrorWidget(Set<Marker> markers) {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map_outlined,
              size: 56.sp,
              color: AppColors.primaryGreen,
            ),
            SizedBox(height: 16.h),
            Text(
              'خريطة حاويات النفايات - المنزلة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<BinBloc>().add(const BinLoadRequested());
    widget.findNearestTrigger?.addListener(_onFindNearestTriggered);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  void _onFindNearestTriggered() {
    if (mounted) showRouteToNearestReadyBin();
  }

  Future<void> _requestLocationPermission() async {
    if (!mounted) return;
    final granted = await LocationPermissionHandler.requestLocationPermission(
      context,
    );
    if (!mounted) return;
    setState(() => _locationPermissionGranted = granted);
    if (granted) {
      await _fetchCurrentLocation();
      if (mounted) {
        await showRouteToNearestReadyBin(showSnackBar: false);
      }
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (mounted) {
        setState(() => _currentPosition = pos);
      }
    } catch (_) {
      // Ignore - user may be in emulator or denied
    }
  }

  Future<void> showRouteToNearestReadyBin({bool showSnackBar = true}) async {
    if (!mounted) return;
    final granted = await LocationPermissionHandler.requestLocationPermission(
      context,
    );
    if (!granted || !mounted) return;

    Position? pos = _currentPosition;
    if (pos == null) {
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
      } catch (_) {
        if (showSnackBar && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'تعذر الحصول على موقعك الحالي',
                textDirection: TextDirection.rtl,
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
        return;
      }
    }
    if (!mounted) return;
    setState(() => _currentPosition = pos);

    final binState = context.read<BinBloc>().state;
    if (binState is! BinLoaded || binState.bins.isEmpty) return;

    final realtimeState = context.read<SmartBinRealtimeBloc>().state;
    final liveMiddleBin = realtimeState is SmartBinRealtimeLoaded
        ? realtimeState.bin(SmartBinConstants.realtimeBinId)
        : null;

    final userLatLng = LatLng(pos!.latitude, pos.longitude);
    BinEntity? nearestReady;
    double minDist = double.infinity;

    for (final bin in binState.bins) {
      if (!_isBinReady(bin: bin, liveMiddleBin: liveMiddleBin)) continue;
      final distance = UserRouteService.straightLineDistanceMeters(
        userLatLng,
        LatLng(bin.latitude, bin.longitude),
      );
      if (distance < minDist) {
        minDist = distance;
        nearestReady = bin;
      }
    }

    if (nearestReady == null) {
      if (showSnackBar && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'لا توجد حاويات جاهزة في المنطقة حالياً',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppColors.warningColor,
          ),
        );
      }
      setState(() => _polylines = {});
      return;
    }

    final destLatLng = LatLng(nearestReady.latitude, nearestReady.longitude);
    final routePoints = await UserRouteService.getStreetRouteGeometry(
      userLatLng,
      destLatLng,
    );

    if (!mounted) return;

    if (routePoints == null || routePoints.length < 2) {
      setState(() => _polylines = {});
      if (showSnackBar && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تعذر حساب مسار الشوارع، حاول مرة أخرى',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppColors.warningColor,
          ),
        );
      }
      return;
    }

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route_to_nearest_ready'),
          points: routePoints,
          color: AppColors.primaryGreen,
          width: 4,
          patterns: [PatternItem.dot, PatternItem.gap(12)],
        ),
      };
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromPoints([userLatLng, destLatLng, ...routePoints]),
        48,
      ),
    );

    if (showSnackBar && mounted) {
      final distText = minDist < 1000
          ? '${minDist.round()} متر'
          : '${(minDist / 1000).toStringAsFixed(1)} كم';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'أقرب حاوية جاهزة: ${nearestReady.name} - على بعد $distText',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(southwest: _mapCenter, northeast: _mapCenter);
    }
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    widget.findNearestTrigger?.removeListener(_onFindNearestTriggered);
    _mapController?.dispose();
    super.dispose();
  }
}
