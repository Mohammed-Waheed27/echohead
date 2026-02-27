import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';
import '../bloc/report_bloc.dart';
import '../sections/report_history_section.dart';

class ReportHistoryPage extends StatelessWidget {
  const ReportHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReportBloc(reportRepository: ServiceLocator.reportRepository)
            ..add(const LoadReportsHistoryEvent()),
      child: const _ReportHistoryView(),
    );
  }
}

class _ReportHistoryView extends StatelessWidget {
  const _ReportHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textOnGreen,
            size: 24.sp,
          ),
          onPressed: () => context.go(RouterNames.home),
        ),
        title: Text(
          'سجل البلاغات',
          style: TextStyle(
            color: AppColors.textOnGreen,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            );
          }

          if (state is ReportHistoryLoadFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.errorColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ReportHistoryLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: ReportHistorySection(reports: state.reports),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
