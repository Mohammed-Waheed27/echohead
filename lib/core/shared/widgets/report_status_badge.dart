import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Features/user/domain/entities/report_entity.dart';
import '../constants/app_colors.dart';

class ReportStatusBadge extends StatelessWidget {
  final ReportStatus status;
  final bool compact;

  const ReportStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  Color _statusColor() {
    switch (status) {
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.w : 10.w,
        vertical: compact ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: _statusColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _statusColor().withOpacity(0.5)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: compact ? 10.sp : 12.sp,
          fontWeight: FontWeight.w600,
          color: _statusColor(),
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
