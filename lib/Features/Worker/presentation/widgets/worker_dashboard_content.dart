import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class WorkerDashboardContent extends StatelessWidget {
  const WorkerDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards
          _buildStatsSection(context),
          SizedBox(height: 24.h),

          // Today's Tasks Section
          _buildSectionTitle('مهام اليوم'),
          SizedBox(height: 12.h),
          _buildTodayTasksSection(context),
          SizedBox(height: 24.h),

          // Quick Actions
          _buildSectionTitle('إجراءات سريعة'),
          SizedBox(height: 12.h),
          _buildQuickActionsSection(context),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'المهام المكتملة',
            '12',
            Icons.check_circle_outline,
            AppColors.successColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'قيد التنفيذ',
            '5',
            Icons.work_outline,
            AppColors.warningColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'المعلقة',
            '3',
            Icons.pending_outlined,
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildTodayTasksSection(BuildContext context) {
    final tasks = [
      {'title': 'تنظيف المنطقة أ', 'status': 'مكتملة', 'color': AppColors.successColor, 'icon': Icons.check_circle},
      {'title': 'تنظيف المنطقة ب', 'status': 'قيد التنفيذ', 'color': AppColors.warningColor, 'icon': Icons.work},
      {'title': 'تنظيف المنطقة ج', 'status': 'معلقة', 'color': AppColors.textSecondary, 'icon': Icons.pending},
      {'title': 'صيانة الحاوية 5', 'status': 'جديدة', 'color': AppColors.primaryGreen, 'icon': Icons.build},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tasks.map((task) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildTaskCard(
            task['title'] as String,
            task['status'] as String,
            task['color'] as Color,
            task['icon'] as IconData,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaskCard(
    String title,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: statusColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final actions = [
      {'title': 'بدء مهمة جديدة', 'icon': Icons.play_circle_outline, 'color': AppColors.primaryGreen},
      {'title': 'تقرير يومي', 'icon': Icons.assignment_outlined, 'color': AppColors.accentTeal},
      {'title': 'طلب إجازة', 'icon': Icons.calendar_today_outlined, 'color': AppColors.warningColor},
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _buildQuickActionCard(
              action['title'] as String,
              action['icon'] as IconData,
              action['color'] as Color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textOnGreen, size: 28.sp),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textOnGreen,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
