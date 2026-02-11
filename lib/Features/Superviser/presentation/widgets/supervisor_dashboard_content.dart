import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class SupervisorDashboardContent extends StatelessWidget {
  const SupervisorDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Overview
          _buildStatsOverview(context),
          SizedBox(height: 24.h),

          // Workers Management Section
          _buildSectionTitle('إدارة العمال'),
          SizedBox(height: 12.h),
          _buildWorkersSection(context),
          SizedBox(height: 24.h),

          // Tasks Overview
          _buildSectionTitle('نظرة عامة على المهام'),
          SizedBox(height: 12.h),
          _buildTasksOverview(context),
          SizedBox(height: 24.h),

          // Quick Actions
          _buildSectionTitle('إجراءات سريعة'),
          SizedBox(height: 12.h),
          _buildQuickActionsGrid(context),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'إجمالي العمال',
            '15',
            Icons.people_outline,
            AppColors.primaryGreen,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'المهام النشطة',
            '23',
            Icons.assignment_outlined,
            AppColors.accentTeal,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'المكتملة اليوم',
            '8',
            Icons.check_circle_outline,
            AppColors.successColor,
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textOnGreen, size: 32.sp),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnGreen,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textOnGreen.withOpacity(0.9),
              ),
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textDirection: TextDirection.rtl,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'عرض الكل',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primaryGreen,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkersSection(BuildContext context) {
    final workers = [
      {'name': 'أحمد محمد', 'status': 'نشط', 'tasks': '5', 'color': AppColors.successColor},
      {'name': 'محمد علي', 'status': 'نشط', 'tasks': '3', 'color': AppColors.successColor},
      {'name': 'خالد أحمد', 'status': 'إجازة', 'tasks': '0', 'color': AppColors.warningColor},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: workers.map((worker) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildWorkerCard(
            worker['name'] as String,
            worker['status'] as String,
            worker['tasks'] as String,
            worker['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkerCard(
    String name,
    String status,
    String tasks,
    Color statusColor,
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
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primaryGreen,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        '$tasks مهام',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTasksOverview(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTaskOverviewCard(
            'مكتملة',
            '8',
            AppColors.successColor,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildTaskOverviewCard(
            'قيد التنفيذ',
            '12',
            AppColors.warningColor,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildTaskOverviewCard(
            'معلقة',
            '3',
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskOverviewCard(
    String title,
    String count,
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
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {'title': 'تخصيص عمال', 'icon': Icons.person_add_outlined, 'color': AppColors.primaryGreen},
      {'title': 'عرض المهام', 'icon': Icons.assignment_outlined, 'color': AppColors.accentTeal},
      {'title': 'تقرير الأداء', 'icon': Icons.assessment_outlined, 'color': AppColors.warningColor},
      {'title': 'الإعدادات', 'icon': Icons.settings_outlined, 'color': AppColors.textSecondary},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildQuickActionCard(
          action['title'] as String,
          action['icon'] as IconData,
          action['color'] as Color,
        );
      },
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
