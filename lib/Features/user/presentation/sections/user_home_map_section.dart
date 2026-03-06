import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_can/core/presentation/bloc/bin_event.dart';
import '../../../../core/domain/entities/bin_entity.dart';
import '../../../../core/presentation/bloc/bin_bloc.dart';
import '../../../../core/presentation/bloc/bin_state.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../../../../core/data/services/user_route_service.dart';
import '../widgets/bin_history_dialog.dart';
import '../widgets/map_legend_overlay.dart';

/// Map centered on Manzalah with bins, current location, and route to nearest.
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
  BinEntity? _highlightedNearestBin;

  /// Manzalah center - المنزلة
  static const LatLng _manzalahCenter = LatLng(31.1582, 31.936);
  static const CameraPosition _initialPosition = CameraPosition(
    target: _manzalahCenter,
    zoom: 15,
  );

  Set<Marker> _buildMarkers(
    List<BinEntity> bins,
    void Function(BinEntity) onTap,
  ) {
    final markers = bins.map((bin) {
      final hue = bin.fillPercent >= 80
          ? BitmapDescriptor.hueRed
          : bin.fillPercent >= 50
              ? BitmapDescriptor.hueYellow
              : BitmapDescriptor.hueGreen;
      return Marker(
        markerId: MarkerId(bin.id),
        position: LatLng(bin.latitude, bin.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: bin.name,
          snippet: 'ممتلئة بنسبة ${bin.fillPercent}%',
        ),
        onTap: () => onTap(bin),
      );
    }).toSet();
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      builder: (context, state) {
        if (state is BinLoading || state is BinInitial) {
          return _buildLoadingWidget();
        }
        if (state is BinError) {
          return _buildErrorStateWidget(state.message);
        }
        final bins = (state as BinLoaded).bins;
        final markers = _buildMarkers(bins, (bin) {
          showDialog(
            context: context,
            builder: (ctx) => BinHistoryDialog(bin: bin),
          );
        });
        return _buildMapContainer(markers);
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
          onCameraIdle: () {},
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
            Icon(Icons.map_outlined, size: 56.sp, color: AppColors.primaryGreen),
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
            SizedBox(height: 8.h),
            Text(
              'حاويات ذكية في منطقة المنزلة',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
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
    if (mounted) showRouteToNearestBin();
  }

  Future<void> _requestLocationPermission() async {
    if (!mounted) return;
    final granted = await LocationPermissionHandler.requestLocationPermission(
      context,
    );
    if (!mounted) return;
    setState(() => _locationPermissionGranted = granted);
    if (granted) {
      _fetchCurrentLocation();
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

  /// Called when user taps "أقرب حاوية" - shows route to nearest bin.
  Future<void> showRouteToNearestBin() async {
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
        if (mounted) {
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

    final state = context.read<BinBloc>().state;
    if (state is! BinLoaded || state.bins.isEmpty) return;

    final userLatLng = LatLng(pos!.latitude, pos.longitude);
    BinEntity? nearest;
    double minDist = double.infinity;
    for (final bin in state.bins) {
      if (bin.isUnderMaintenance) continue;
      final d = UserRouteService.straightLineDistanceMeters(
        userLatLng,
        LatLng(bin.latitude, bin.longitude),
      );
      if (d < minDist) {
        minDist = d;
        nearest = bin;
      }
    }

    if (nearest == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'لا توجد حاويات متاحة في المنطقة',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppColors.warningColor,
          ),
        );
      }
      return;
    }

    final destLatLng = LatLng(nearest.latitude, nearest.longitude);
    final routePoints = await UserRouteService.getRouteGeometry(
      userLatLng,
      destLatLng,
    );

    if (!mounted) return;
    setState(() {
      _highlightedNearestBin = nearest;
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route_to_nearest'),
          points: routePoints ??
              [userLatLng, destLatLng],
          color: AppColors.primaryGreen,
          width: 5,
        ),
      };
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromPoints([
          userLatLng,
          destLatLng,
          ...?routePoints,
        ]),
        48,
      ),
    );

    final distText = minDist < 1000
        ? '${minDist.round()} متر'
        : '${(minDist / 1000).toStringAsFixed(1)} كم';
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'أقرب حاوية: ${nearest.name} - على بعد $distText',
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
      return LatLngBounds(
        southwest: _manzalahCenter,
        northeast: _manzalahCenter,
      );
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
