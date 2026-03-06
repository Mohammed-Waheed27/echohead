import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/entities/bin_entity.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/time_ago_helper.dart';

/// Dialog showing bin history: last 5 readings, last emptied, last report.
class BinHistoryDialog extends StatelessWidget {
  final BinEntity bin;

  const BinHistoryDialog({super.key, required this.bin});

  @override
  Widget build(BuildContext context) {
    final lastReadings = bin.lastReadings.take(5).toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.primaryGreen,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bin.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formatTimeAgo(bin.lastUpdatedAt),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),    
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildSectionTitle('آخر 5 قراءات'),
              SizedBox(height: 8.h),
              if (lastReadings.isEmpty)
                Text(
                  'لا توجد قراءات',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),  
                )
              else
                ...lastReadings.map((r) => _buildReadingRow(r)),
              SizedBox(height: 16.h),
              _buildSectionTitle('آخر تفريغ'),
              SizedBox(height: 8.h),
              _buildInfoRow(
                bin.lastEmptiedAt != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(bin.lastEmptiedAt!)
                    : 'لا يوجد',
                Icons.cleaning_services_outlined,
              ),
              SizedBox(height: 16.h),
              _buildSectionTitle('آخر بلاغ'),
              SizedBox(height: 8.h),
              if (bin.lastReportAt != null) ...[
                _buildInfoRow(
                  DateFormat('dd/MM/yyyy HH:mm').format(bin.lastReportAt!),
                  Icons.report_outlined,
                ),
                if (bin.lastReportDescription != null) ...[
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      bin.lastReportDescription!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ] else
                Text(
                  'لا يوجد بلاغات',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _buildBadge(
                    'صحة البطارية: ${bin.batteryHealthLabel}',
                    _batteryColor(bin.batteryHealth),
                  ),
                  SizedBox(width: 8.w),
                  _buildBadge(
                    'الأولوية: ${bin.priorityLabel}',
                    _priorityColor(bin.priority),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'إغلاق',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildReadingRow(BinReading r) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${r.fillPercent}% امتلاء - غاز ${r.gasLevel.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            DateFormat('HH:mm').format(r.timestamp),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primaryGreen),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _batteryColor(BatteryHealth h) {
    switch (h) {
      case BatteryHealth.good:
        return AppColors.successColor;
      case BatteryHealth.warning:
        return AppColors.warningColor;
      case BatteryHealth.critical:
        return AppColors.errorColor;
    }
  }

  Color _priorityColor(BinPriority p) {
    switch (p) {
      case BinPriority.low:
        return AppColors.successColor;
      case BinPriority.medium:
        return AppColors.warningColor;
      case BinPriority.high:
        return AppColors.errorColor;
    }
  }
}
