import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

/// Reusable section containing task stats and task list.
class SupervisorTasksSection extends StatelessWidget {
  const SupervisorTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TaskStatsRow(),
          SizedBox(height: 24.h),
          Text(
            'المهام الحالية',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 12.h),
          const TaskListSection(),
        ],
      ),
    );
  }
}

class TaskStatsRow extends StatelessWidget {
  const TaskStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TaskStatCard('مكتملة', '8', AppColors.successColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TaskStatCard('قيد التنفيذ', '12', AppColors.warningColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TaskStatCard('معلقة', '3', AppColors.textSecondary),
        ),
      ],
    );
  }
}

class TaskStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const TaskStatCard(this.title, this.count, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TaskListSection extends StatelessWidget {
  const TaskListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': 'تنظيف حاوية زمالك',
        'worker': 'أحمد محمد',
        'status': 'قيد التنفيذ',
        'color': AppColors.warningColor,
      },
      {
        'title': 'صيانة حاوية المعادي',
        'worker': 'محمد علي',
        'status': 'معلقة',
        'color': AppColors.textSecondary,
      },
      {
        'title': 'تنظيف حاوية هليوبوليس',
        'worker': 'سعيد حسن',
        'status': 'مكتملة',
        'color': AppColors.successColor,
      },
    ];

    return Column(
      children: tasks.map((t) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: TaskListTile(
            title: t['title'] as String,
            worker: t['worker'] as String,
            status: t['status'] as String,
            statusColor: t['color'] as Color,
          ),
        );
      }).toList(),
    );
  }
}

class TaskListTile extends StatelessWidget {
  final String title;
  final String worker;
  final String status;
  final Color statusColor;

  const TaskListTile({
    required this.title,
    required this.worker,
    required this.status,
    required this.statusColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textDirection: TextDirection.rtl,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.person_outline, size: 16.sp, color: AppColors.textSecondary),
              SizedBox(width: 6.w),
              Text(
                worker,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
