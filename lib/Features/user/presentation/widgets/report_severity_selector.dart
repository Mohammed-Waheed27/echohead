import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../domain/entities/report_entity.dart';

class ReportSeveritySelector extends StatelessWidget {
  final ReportSeverity? selectedSeverity;
  final ValueChanged<ReportSeverity?> onChanged;

  const ReportSeveritySelector({
    super.key,
    this.selectedSeverity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.primaryGreen,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'درجة خطورة البلاغ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        DropdownButtonFormField<ReportSeverity>(
          value: selectedSeverity,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          items: ReportSeverity.values.map((severity) {
            return DropdownMenuItem<ReportSeverity>(
              value: severity,
              child: Row(
                children: [
                  _severityIcon(severity),
                  SizedBox(width: 8.w),
                  Text(
                    severity.displayName,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            'اختر درجة الخطورة',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _severityIcon(ReportSeverity severity) {
    Color color;
    IconData icon;
    switch (severity) {
      case ReportSeverity.low:
        color = AppColors.successColor;
        icon = Icons.arrow_downward;
        break;
      case ReportSeverity.medium:
        color = AppColors.warningColor;
        icon = Icons.remove;
        break;
      case ReportSeverity.high:
        color = AppColors.errorColor;
        icon = Icons.arrow_upward;
        break;
    }
    return Icon(icon, size: 18.sp, color: color);
  }
}
