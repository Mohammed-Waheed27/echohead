import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import 'report_text_field.dart';

class ReportLocationField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onLocationObtained;
  final ValueChanged<(double, double)?> onCoordinatesObtained;

  const ReportLocationField({
    super.key,
    required this.controller,
    this.onLocationObtained,
    required this.onCoordinatesObtained,
  });

  void _applyPosition(
    BuildContext context,
    Position position, {
    bool isCached = false,
  }) {
    final lat = position.latitude;
    final lng = position.longitude;
    final address = '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';

    controller.text = address;
    onLocationObtained?.call();
    onCoordinatesObtained((lat, lng));

    if (context.mounted && isCached) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم استخدام آخر موقع معروف (قد يكون قديماً)',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppColors.infoColor,
        ),
      );
    }
  }

  String _getErrorMessage(Object e) {
    if (e.toString().contains('TimeoutException') ||
        e.toString().contains('timeout')) {
      return 'انتهت مهلة الحصول على الموقع. تأكد من تفعيل الموقع ومحاولة الخارج أو بالقرب من نافذة.';
    }
    if (e is LocationServiceDisabledException) {
      return 'خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز.';
    }
    if (e.toString().contains('denied') || e.toString().contains('permission')) {
      return 'تم رفض إذن الموقع. يرجى تمكينه من إعدادات التطبيق.';
    }
    return 'تعذر الحصول على الموقع. تأكد من تفعيل الموقع وحاول مرة أخرى.';
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    final hasPermission =
        await LocationPermissionHandler.requestLocationPermission(context);
    if (!hasPermission || !context.mounted) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      ).timeout(
        const Duration(seconds: 16),
        onTimeout: () => throw TimeoutException('Location timeout'),
      );

      if (!context.mounted) return;

      _applyPosition(context, position);
    } catch (e) {
      if (!context.mounted) return;

      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null && context.mounted) {
        _applyPosition(context, lastPosition, isCached: true);
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getErrorMessage(e),
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportTextField(
          controller: controller,
          label: 'الموقع',
          hint: 'اضغط على زر الموقع لتحديد موقعك تلقائياً أو اكتبه يدوياً',
          icon: Icons.location_on_outlined,
          maxLines: 1,
          isRequired: false,
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _getCurrentLocation(context),
            icon: Icon(
              Icons.my_location,
              size: 20.sp,
              color: AppColors.primaryGreen,
            ),
            label: Text(
              'استخدام موقعي الحالي',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.rtl,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
