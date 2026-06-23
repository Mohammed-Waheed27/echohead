import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../../../Features/user/domain/entities/report_entity.dart';

class ReportFilterChips extends StatelessWidget {
  final ReportStatus? selectedStatus;
  final ValueChanged<ReportStatus?> onChanged;
  final bool showAll;

  const ReportFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
    this.showAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          if (showAll) _buildChip(context, null, 'الكل'),
          _buildChip(context, ReportStatus.pending, 'قيد المراجعة'),
          _buildChip(context, ReportStatus.inProgress, 'قيد المعالجة'),
          _buildChip(context, ReportStatus.resolved, 'تم الحل'),
          _buildChip(context, ReportStatus.rejected, 'مرفوض'),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, ReportStatus? status, String label) {
    final isSelected = selectedStatus == status;
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: FilterChip(
        label: Text(
          label,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 12.sp,
            color: isSelected ? AppColors.textOnGreen : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onChanged(status),
        selectedColor: AppColors.primaryGreen,
        backgroundColor: AppColors.surfaceColor,
        checkmarkColor: AppColors.textOnGreen,
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.borderColor,
        ),
      ),
    );
  }
}
