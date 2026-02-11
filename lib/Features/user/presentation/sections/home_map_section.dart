import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';

class HomeMapSection extends StatefulWidget {
  const HomeMapSection({super.key});

  @override
  State<HomeMapSection> createState() => _HomeMapSectionState();
}

class _HomeMapSectionState extends State<HomeMapSection> {
  GoogleMapController? _mapController;
  bool _hasError = false;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo, Egypt coordinates
    zoom: 13,
  );

  // Trash can locations in Cairo, Egypt
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('trash_can_1'),
      position: const LatLng(30.0444, 31.2357), // Downtown Cairo (Tahrir Square area)
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'حاوية نفايات ذكية 1'),
    ),
    Marker(
      markerId: const MarkerId('trash_can_2'),
      position: const LatLng(30.0626, 31.2197), // Zamalek
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'حاوية نفايات ذكية 2'),
    ),
    Marker(
      markerId: const MarkerId('trash_can_3'),
      position: const LatLng(30.0875, 31.3200), // Heliopolis
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'حاوية نفايات ذكية 3'),
    ),
    Marker(
      markerId: const MarkerId('trash_can_4'),
      position: const LatLng(29.9600, 31.2600), // Maadi
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'حاوية نفايات ذكية 4'),
    ),
    Marker(
      markerId: const MarkerId('trash_can_5'),
      position: const LatLng(30.0628, 31.3200), // Nasr City
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'حاوية نفايات ذكية 5'),
    ),
  };

  @override
  Widget build(BuildContext context) {
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
            ? _buildErrorWidget(context)
            : _buildMapWidget(context),
      ),
    );
  }

  Widget _buildMapWidget(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      markers: _markers,
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
      onCameraMoveStarted: () {},
      onCameraIdle: () {},
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
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
                '5 حاويات نفايات ذكية في المنطقة',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            // Show trash can locations as a list
            ...List.generate(
              _markers.length,
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
                      'حاوية نفايات ذكية ${index + 1}',
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
