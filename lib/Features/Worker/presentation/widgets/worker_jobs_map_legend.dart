import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class WorkerJobsMapLegend extends StatelessWidget {
  const WorkerJobsMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: Container(
        margin: EdgeInsets.only(top: 40.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withOpacity(0.92),
          borderRadius: BorderRadius.circular(12.r),
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
            _LegendRow(
              color: AppColors.primaryGreen,
              label: 'تنظيف',
              icon: Icons.cleaning_services,
            ),
            SizedBox(height: 6.h),
            _LegendRow(
              color: AppColors.warningColor,
              label: 'صيانة',
              icon: Icons.build,
            ),
            SizedBox(height: 6.h),
            _LegendRow(
              color: AppColors.successColor,
              label: 'مكتملة',
              icon: Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.icon,
  });

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
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
