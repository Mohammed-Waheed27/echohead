import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../domain/repositories/worker_job_repository.dart';
import '../bloc/worker_job_bloc.dart';
import '../sections/worker_jobs_map_section.dart';
import '../widgets/worker_job_info_dialog.dart';
import '../widgets/worker_job_list_item.dart';

class WorkerJobsPage extends StatelessWidget {
  const WorkerJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkerJobBloc(
        jobRepository: ServiceLocator.workerJobRepository,
      )..add(const WorkerJobLoadRequested()),
      child: const _WorkerJobsPageView(),
    );
  }
}

class _WorkerJobsPageView extends StatelessWidget {
  const _WorkerJobsPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'المهام المُعينّة',
          textDirection: TextDirection.rtl,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<WorkerJobBloc, WorkerJobState>(
        builder: (context, state) {
          if (state is WorkerJobLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkerJobError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  state.message,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (state is! WorkerJobLoaded) {
            return const SizedBox.shrink();
          }
          final loadedState = state as WorkerJobLoaded;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (loadedState.pendingJobs.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<WorkerJobBloc>()
                            .add(const WorkerJobShowOptimizedRouteRequested());
                      },
                      icon: Icon(Icons.route, size: 22.sp),
                      label: Text(
                        'أقصر مسار لإنجاز المهام',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentTeal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                WorkerJobsMapSection(),
                SizedBox(height: 24.h),
                Text(
                  'قائمة المهام',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 12.h),
                ...loadedState.jobs.map(
                  (job) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: WorkerJobListItem(
                      job: job,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => BlocProvider.value(
                            value: context.read<WorkerJobBloc>(),
                            child: WorkerJobInfoDialog(job: job),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
