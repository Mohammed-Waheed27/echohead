import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_error_view.dart';
import '../../../../core/shared/widgets/report_filter_chips.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../bloc/worker_report_bloc.dart';
import '../widgets/worker_report_card.dart';
import '../widgets/worker_report_details_dialog.dart';

class WorkerReportsSection extends StatelessWidget {
  const WorkerReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerReportBloc, WorkerReportState>(
      builder: (context, state) {
        if (state is WorkerReportLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          );
        }

        if (state is WorkerReportError) {
          return ReportErrorView(
            message: state.message,
            onRetry: () => context.read<WorkerReportBloc>().add(
              const WorkerWatchReportsEvent(),
            ),
          );
        }

        if (state is WorkerReportLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsRow(state),
              SizedBox(height: 16.h),
              ReportFilterChips(
                selectedStatus: state.filterStatus,
                onChanged: (status) => context.read<WorkerReportBloc>().add(
                  WorkerFilterReportsEvent(status: status),
                ),
              ),
              SizedBox(height: 16.h),
              if (state.reports.isEmpty)
                _buildEmptyState()
              else
                ...state.reports.map(
                  (report) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: WorkerReportCard(
                      report: report,
                      onTap: () => _openDetails(context, report),
                    ),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatsRow(WorkerReportLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            'بلاغات جديدة',
            state.pendingCount,
            AppColors.warningColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _statBox(
            'قيد المعالجة',
            state.inProgressCount,
            AppColors.infoColor,
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Icon(Icons.task_alt, size: 64.sp, color: AppColors.successColor),
          SizedBox(height: 12.h),
          Text(
            'لا توجد بلاغات تحتاج معالجة',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, ReportEntity report) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkerReportBloc>(),
        child: WorkerReportDetailsDialog(report: report),
      ),
    );
  }
}
