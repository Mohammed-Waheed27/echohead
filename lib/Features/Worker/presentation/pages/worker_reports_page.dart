import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../bloc/worker_report_bloc.dart';
import '../sections/worker_reports_section.dart';

class WorkerReportsPage extends StatelessWidget {
  const WorkerReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkerReportBloc(
        reportRepository: ServiceLocator.reportRepository,
        sharedPreferences: ServiceLocator.sharedPreferences,
      )..add(const WorkerWatchReportsEvent()),
      child: const _WorkerReportsView(),
    );
  }
}

class _WorkerReportsView extends StatelessWidget {
  const _WorkerReportsView();

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
          onPressed: () => context.go(RouterNames.dashboardWorker),
        ),
        title: Text(
          'بلاغات المستخدمين',
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
        child: const WorkerReportsSection(),
      ),
    );
  }
}
