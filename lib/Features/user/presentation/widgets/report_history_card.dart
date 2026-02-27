import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../domain/entities/report_entity.dart';

class ReportHistoryCard extends StatelessWidget {
  final ReportEntity report;

  const ReportHistoryCard({super.key, required this.report});

  Color _statusColor() {
    switch (report.status) {
      case ReportStatus.pending:
        return AppColors.warningColor;
      case ReportStatus.inProgress:
        return AppColors.infoColor;
      case ReportStatus.resolved:
        return AppColors.successColor;
      case ReportStatus.rejected:
        return AppColors.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d/M/yyyy - h:mm a', 'ar');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.3),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: _statusColor().withOpacity(0.5)),
                ),
                child: Text(
                  report.status.displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 14.sp,
                color: _severityColor(report.severity),
              ),
              SizedBox(width: 4.w),
              Text(
                report.severity.displayName,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                dateFormat.format(report.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
                ),
            ],
          ),
          if (report.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              report.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (report.address != null && report.address!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.sp,
                  color: AppColors.primaryGreen,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    report.address!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (report.imagePath != null &&
              report.imagePath!.isNotEmpty &&
              File(report.imagePath!).existsSync()) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                File(report.imagePath!),
                height: 80.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _severityColor(ReportSeverity severity) {
    switch (severity) {
      case ReportSeverity.low:
        return AppColors.successColor;
      case ReportSeverity.medium:
        return AppColors.warningColor;
      case ReportSeverity.high:
        return AppColors.errorColor;
    }
  }
}
