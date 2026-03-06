import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';

class SupervisorTasksPage extends StatelessWidget {
  const SupervisorTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RouterNames.dashboardSupervisor);
      },
      child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouterNames.dashboardSupervisor),
        ),
        title: Text(
          'عرض المهام',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _TaskStatCard('مكتملة', '8', AppColors.successColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TaskStatCard('قيد التنفيذ', '12', AppColors.warningColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TaskStatCard('معلقة', '3', AppColors.textSecondary),
                ),
              ],
            ),
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
            _TaskListSection(),
          ],
        ),
      ),
      ),
    );
  }
}

class _TaskStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _TaskStatCard(this.title, this.count, this.color);

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

class _TaskListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = [
      {'title': 'تنظيف حاوية زمالك', 'worker': 'أحمد محمد', 'status': 'قيد التنفيذ', 'color': AppColors.warningColor},
      {'title': 'صيانة حاوية المعادي', 'worker': 'محمد علي', 'status': 'معلقة', 'color': AppColors.textSecondary},
      {'title': 'تنظيف حاوية هليوبوليس', 'worker': 'سعيد حسن', 'status': 'مكتملة', 'color': AppColors.successColor},
    ];

    return Column(
      children: tasks.map((t) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
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
                      t['title'] as String,
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
                        color: (t['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        t['status'] as String,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: t['color'] as Color,
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
                      t['worker'] as String,
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
        );
      }).toList(),
    );
  }
}
