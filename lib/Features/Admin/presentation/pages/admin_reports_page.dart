import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../bloc/admin_report_bloc.dart';
import '../sections/admin_reports_section.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminReportBloc(reportRepository: ServiceLocator.reportRepository)
            ..add(const AdminWatchReportsEvent()),
      child: const _AdminReportsView(),
    );
  }
}

class _AdminReportsView extends StatelessWidget {
  const _AdminReportsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => context.go(RouterNames.dashboardAdmin),
        ),
        title: Text(
          'إدارة البلاغات',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textOnGreen,
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: const AdminReportsSection(),
      ),
    );
  }
}
