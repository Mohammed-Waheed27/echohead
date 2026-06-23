import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_status_badge.dart';
import 'report_deletion_countdown.dart';
import '../../domain/entities/report_entity.dart';

class ReportHistoryCard extends StatelessWidget {
  final ReportEntity report;

  const ReportHistoryCard({super.key, required this.report});

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
              ReportStatusBadge(status: report.status),
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
              maxLines: 3,
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
          if (report.workerResponse != null &&
              report.workerResponse!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.infoColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.infoColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        size: 16.sp,
                        color: AppColors.infoColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'رد العامل${report.workerName != null ? ' (${report.workerName})' : ''}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.infoColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    report.workerResponse!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (report.adminNote != null && report.adminNote!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.warningColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 16.sp,
                        color: AppColors.warningColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'ملاحظة الإدارة',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warningColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    report.adminNote!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (report.isResolved && report.scheduledDeleteAt != null) ...[
            SizedBox(height: 8.h),
            ReportDeletionCountdown(report: report),
          ],
          if (_hasImage()) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImage(),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasImage() {
    if (report.imageUrl != null && report.imageUrl!.isNotEmpty) return true;
    if (report.imagePath != null &&
        report.imagePath!.isNotEmpty &&
        File(report.imagePath!).existsSync()) {
      return true;
    }
    return false;
  }

  Widget _buildImage() {
    if (report.imageUrl != null && report.imageUrl!.isNotEmpty) {
      return Image.network(
        report.imageUrl!,
        height: 100.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }
    return Image.file(
      File(report.imagePath!),
      height: 100.h,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
