import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/domain/entities/bin_entity.dart';
import '../../../../core/presentation/bloc/bin_bloc.dart';
import '../../../../core/presentation/bloc/bin_state.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../widgets/bin_history_dialog.dart';
import '../widgets/map_legend_overlay.dart';

class HomeMapSection extends StatefulWidget {
  final VoidCallback? onMapInteraction;

  const HomeMapSection({super.key, this.onMapInteraction});

  @override
  State<HomeMapSection> createState() => _HomeMapSectionState();
}

class _HomeMapSectionState extends State<HomeMapSection> {
  GoogleMapController? _mapController;
  bool _hasError = false;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.1582, 31.936), // Manzalah - المنزلة
    zoom: 15,
  );

  Set<Marker> _buildMarkers(List<BinEntity> bins, void Function(BinEntity) onTap) {
    return bins.map((bin) {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      builder: (context, state) {
        if (state is BinLoading || state is BinInitial) {
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
        if (state is BinError) {
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
                state.message,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: AppColors.errorColor, fontSize: 14.sp),
              ),
            ),
          );
        }
        final bins = (state as BinLoaded).bins;
        final markers = _buildMarkers(bins, (bin) {
          showDialog(
            context: context,
            builder: (ctx) => BinHistoryDialog(bin: bin),
          );
        });
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
                ? _buildErrorWidget(context, bins)
                : _buildMapWidget(context, markers),
          ),
        );
      },
    );
  }

  Widget _buildMapWidget(BuildContext context, Set<Marker> markers) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: markers,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            if (mounted) {
              setState(() {
                _hasError = false;
              });
            }
          },
          mapToolbarEnabled: false,
          onCameraMoveStarted: () => widget.onMapInteraction?.call(),
          onCameraIdle: () {},
        ),
        const MapLegendOverlay(),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, List<BinEntity> bins) {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 56.sp,
              color: AppColors.primaryGreen,
            ),
            SizedBox(height: 16.h),
            Text(
              'خريطة حاويات النفايات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                '${bins.length} حاويات نفايات ذكية في المنطقة',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            ...List.generate(
              bins.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.primaryGreen,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      bins[index].name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Request location permission when map initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  Future<void> _requestLocationPermission() async {
    if (!mounted) return;
    final context = this.context;
    await LocationPermissionHandler.requestLocationPermission(context);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
