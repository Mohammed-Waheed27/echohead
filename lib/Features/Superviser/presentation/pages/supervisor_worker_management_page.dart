import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';

class SupervisorWorkerManagementPage extends StatelessWidget {
  const SupervisorWorkerManagementPage({super.key});

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
          'إدارة العمال',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => context.push(RouterNames.supervisorAddWorker),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WorkerManagementStats(),
            SizedBox(height: 24.h),
            Text(
              'قائمة العمال',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 12.h),
            _WorkerListSection(),
          ],
        ),
      ),
      ),
    );
  }
}

class _WorkerManagementStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('إجمالي العمال', '15', AppColors.primaryGreen),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('النشطين', '12', AppColors.successColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard('في إجازة', '3', AppColors.warningColor),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
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

class _WorkerListSection extends StatelessWidget {
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
          child: _WorkerCard(
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

class _WorkerCard extends StatelessWidget {
  final String name;
  final String status;
  final String tasks;
  final Color statusColor;

  const _WorkerCard({
    required this.name,
    required this.status,
    required this.tasks,
    required this.statusColor,
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
