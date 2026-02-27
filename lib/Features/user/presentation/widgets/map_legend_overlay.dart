import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

/// Compact overlay legend indicating trash can marker colors.
class MapLegendOverlay extends StatelessWidget {
  const MapLegendOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      left: 12.w,
      child: Container(
        margin: EdgeInsets.only(top: 40.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withOpacity(0.92),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendRow(color: AppColors.errorColor, label: 'ممتلئة'),
            SizedBox(height: 4.h),
            _LegendRow(color: AppColors.warningColor, label: 'شبه ممتلئة'),
            SizedBox(height: 4.h),
            _LegendRow(color: AppColors.primaryGreen, label: 'جاهزة'),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.2),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 2),
            ],
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
