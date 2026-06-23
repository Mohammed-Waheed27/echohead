import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_status_badge.dart';
import '../../../user/domain/entities/report_entity.dart';

class WorkerReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback onTap;

  const WorkerReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  Color _severityColor() {
    switch (report.severity) {
      case ReportSeverity.low:
        return AppColors.successColor;
      case ReportSeverity.medium:
        return AppColors.warningColor;
      case ReportSeverity.high:
        return AppColors.errorColor;
    }
  }

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
          border: Border.all(
            color: report.severity == ReportSeverity.high
                ? AppColors.errorColor.withOpacity(0.4)
                : AppColors.borderColor,
            width: report.severity == ReportSeverity.high ? 1.5 : 1,
          ),
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
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _severityColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.report_problem_outlined,
                    color: _severityColor(),
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.issueType,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        report.severity.displayName,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: _severityColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                ReportStatusBadge(status: report.status, compact: true),
              ],
            ),
            SizedBox(height: 8.h),
            if (report.description.isNotEmpty)
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 13.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  report.userName,
                  style: TextStyle(
                    fontSize: 11.sp,
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
          ],
        ),
      ),
    );
  }
}
