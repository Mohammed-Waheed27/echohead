import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_status_badge.dart';
import '../../../user/domain/entities/report_entity.dart';

class AdminReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback onTap;

  const AdminReportCard({super.key, required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d/M/yyyy - h:mm a', 'ar');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.borderColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.issueType,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                ReportStatusBadge(status: report.status),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
                children: [
                Icon(
                  Icons.person_outline,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  report.userName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormat.format(report.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (report.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (report.workerName != null) ...[
              SizedBox(height: 6.h),
              Text(
                'العامل: ${report.workerName}',
                style: TextStyle(fontSize: 11.sp, color: AppColors.infoColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
