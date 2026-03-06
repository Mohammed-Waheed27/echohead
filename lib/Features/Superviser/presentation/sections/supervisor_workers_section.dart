import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

/// Reusable section containing worker stats and worker list.
/// [onAddWorker] callback is invoked when the add worker action is triggered.
class SupervisorWorkersSection extends StatelessWidget {
  final VoidCallback? onAddWorker;

  const SupervisorWorkersSection({
    super.key,
    this.onAddWorker,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WorkerStatsRow(),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onAddWorker != null)
                TextButton.icon(
                  onPressed: onAddWorker,
                  icon: Icon(Icons.person_add, size: 18.sp, color: AppColors.primaryGreen),
                  label: Text(
                    'إضافة عامل',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              Expanded(
                child: Text(
                  'قائمة العمال',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const WorkerListSection(),
        ],
      ),
    );
  }
}

class WorkerStatsRow extends StatelessWidget {
  const WorkerStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WorkerStatCard('إجمالي العمال', '15', AppColors.primaryGreen),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: WorkerStatCard('النشطين', '12', AppColors.successColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: WorkerStatCard('في إجازة', '3', AppColors.warningColor),
        ),
      ],
    );
  }
}

class WorkerStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const WorkerStatCard(this.title, this.value, this.color, {super.key});

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
            value,
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

class WorkerListSection extends StatelessWidget {
  const WorkerListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = [
      {'name': 'أحمد محمد', 'status': 'نشط', 'tasks': '5', 'color': AppColors.successColor},
      {'name': 'محمد علي', 'status': 'نشط', 'tasks': '3', 'color': AppColors.successColor},
      {'name': 'خالد أحمد', 'status': 'إجازة', 'tasks': '0', 'color': AppColors.warningColor},
      {'name': 'سعيد حسن', 'status': 'نشط', 'tasks': '4', 'color': AppColors.successColor},
    ];

    return Column(
      children: workers.map((w) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: WorkerCard(
            name: w['name'] as String,
            status: w['status'] as String,
            tasks: w['tasks'] as String,
            statusColor: w['color'] as Color,
          ),
        );
      }).toList(),
    );
  }
}

class WorkerCard extends StatelessWidget {
  final String name;
  final String status;
  final String tasks;
  final Color statusColor;

  const WorkerCard({
    required this.name,
    required this.status,
    required this.tasks,
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
            child: Icon(Icons.person, color: AppColors.primaryGreen, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
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
                ),
                SizedBox(height: 4.h),
                Row(
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
                    Text(
                      '$status • $tasks مهام',
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
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.primaryGreen),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
