import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/router_names.dart';
import 'package:trash_can/core/presentation/bloc/bin_state.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/domain/entities/bin_entity.dart';
import '../../../../core/presentation/bloc/bin_bloc.dart';
import '../../../../core/presentation/bloc/bin_event.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../user/presentation/widgets/bin_history_dialog.dart';
import '../../../user/presentation/widgets/bin_list_tile.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../bloc/worker_job_bloc.dart';
import '../sections/worker_jobs_map_section.dart';
import '../widgets/worker_job_info_dialog.dart';
import '../widgets/worker_job_list_item.dart';

class WorkerJobsPage extends StatelessWidget {
  const WorkerJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WorkerJobBloc(
            jobRepository: ServiceLocator.workerJobRepository,
            binRepository: ServiceLocator.binRepository,
          )..add(const WorkerJobLoadRequested()),
        ),
        BlocProvider(
          create: (context) => BinBloc(
            binRepository: ServiceLocator.binRepository,
          )..add(const BinLoadRequested()),
        ),
      ],
      child: const _WorkerJobsPageView(),
    );
  }
}

class _WorkerJobsPageView extends StatelessWidget {
  const _WorkerJobsPageView();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouterNames.dashboardWorker);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouterNames.dashboardWorker);
              }
            },
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
        body: Stack(
        children: [
          BlocBuilder<WorkerJobBloc, WorkerJobState>(
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
              final canShowRoute = loadedState.pendingJobs.length >= 2;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: ElevatedButton.icon(
                    onPressed: canShowRoute && !loadedState.isComputingRoute
                        ? () {
                            context.read<WorkerJobBloc>().add(
                                  const WorkerJobShowOptimizedRouteRequested(),
                                );
                          }
                        : null,
                    icon: loadedState.isComputingRoute
                        ? SizedBox(
                            width: 22.sp,
                            height: 22.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.route, size: 22.sp),
                    label: Text(
                      loadedState.isComputingRoute
                          ? 'جاري حساب المسار...'
                          : canShowRoute
                              ? 'أقصر مسار لإنجاز المهام'
                              : loadedState.pendingJobs.isEmpty
                              ? 'جميع المهام مكتملة'
                              : 'يجب وجود مهمتين لعرض المسار',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canShowRoute
                          ? AppColors.accentTeal
                          : AppColors.textSecondary,
                      disabledBackgroundColor: AppColors.borderColor,
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
                      onTap: () => _showJobDialog(context, job),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _WorkerBinsSection(),
              ],
            ),
          );
        },
      ),
          BlocBuilder<BinBloc, BinState>(
            buildWhen: (p, c) =>
                (p is BinLoaded && c is BinLoaded) &&
                (p.hasGasEmergency != c.hasGasEmergency),
            builder: (context, state) {
              if (state is! BinLoaded || !state.hasGasEmergency) {
                return const SizedBox.shrink();
              }
              return _GasEmergencyOverlay();
            },
          ),
        ],
      ),
    ));
  }

  void _showJobDialog(BuildContext context, WorkerJobEntity job) {
    final bin = context.read<BinBloc>().state is BinLoaded
        ? _findMatchingBin(
            (context.read<BinBloc>().state as BinLoaded).bins,
            job.latitude,
            job.longitude,
          )
        : null;
    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WorkerJobBloc>()),
          BlocProvider.value(value: context.read<BinBloc>()),
        ],
        child: WorkerJobInfoDialog(job: job, bin: bin),
      ),
    );
  }

  BinEntity? _findMatchingBin(
    List<BinEntity> bins,
    double lat,
    double lng,
  ) {
    for (final b in bins) {
      if ((b.latitude - lat).abs() < 0.001 &&
          (b.longitude - lng).abs() < 0.001) {
        return b;
      }
    }
    return null;
  }
}

class _GasEmergencyOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.errorColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.errorColor.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تنبيه طوارئ الغاز',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'مستوى الغاز مرتفع جداً - يرجى التعامل فوراً',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkerBinsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinBloc, BinState>(
      builder: (context, state) {
        if (state is! BinLoaded || state.bins.isEmpty) {
          return const SizedBox.shrink();
        }
        final workerBins = state.bins.where((b) => !b.isUnderMaintenance).toList();
        if (workerBins.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'الحاويات (آخر تحديث)',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 12.h),
            ...workerBins.map(
              (bin) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: BinListTile(bin: bin),
              ),
            ),
          ],
        );
      },
    );
  }
}
