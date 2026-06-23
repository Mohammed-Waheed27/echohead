import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_bloc.dart';
import '../../../../core/presentation/bloc/smart_bin_realtime_event.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../sections/worker_smart_bins_map_section.dart';

class WorkerSmartBinsMapTab extends StatelessWidget {
  const WorkerSmartBinsMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SmartBinRealtimeBloc(
        repository: ServiceLocator.smartBinRealtimeRepository,
      )..add(const SmartBinRealtimeWatchAllRequested()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'خريطة الحاويات الذكية المباشرة',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'الحاوية المركزية متصلة بقاعدة البيانات المباشرة، والباقي ضمن دائرة 300 متر',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: const WorkerSmartBinsMapSection(),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
