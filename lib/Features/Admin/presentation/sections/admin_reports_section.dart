import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_error_view.dart';
import '../../../../core/shared/widgets/report_filter_chips.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../bloc/admin_report_bloc.dart';
import '../widgets/admin_report_card.dart';
import '../widgets/admin_report_details_dialog.dart';

class AdminReportsSection extends StatelessWidget {
  const AdminReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminReportBloc, AdminReportState>(
      builder: (context, state) {
        if (state is AdminReportLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          );
        }

        if (state is AdminReportError) {
          return ReportErrorView(
            message: state.message,
            onRetry: () => context.read<AdminReportBloc>().add(
              const AdminWatchReportsEvent(),
            ),
          );
        }

        if (state is AdminReportLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsRow(state),
              SizedBox(height: 16.h),
              ReportFilterChips(
                selectedStatus: state.filterStatus,
                onChanged: (status) => context.read<AdminReportBloc>().add(
                  AdminFilterReportsEvent(status: status),
                ),
              ),
              SizedBox(height: 16.h),
              if (state.reports.isEmpty)
                _buildEmptyState()
              else
                ...state.reports.map(
                  (report) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: AdminReportCard(
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

  Widget _buildStatsRow(AdminReportLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            'قيد المراجعة',
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
        SizedBox(width: 8.w),
        Expanded(
          child: _statBox(
            'تم الحل',
            state.resolvedCount,
            AppColors.successColor,
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
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
          Icon(
            Icons.inbox_outlined,
            size: 64.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد بلاغات',
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
        value: context.read<AdminReportBloc>(),
        child: AdminReportDetailsDialog(report: report),
      ),
    );
  }
}
