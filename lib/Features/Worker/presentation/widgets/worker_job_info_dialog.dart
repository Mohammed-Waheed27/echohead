import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../bloc/worker_job_bloc.dart';

class WorkerJobInfoDialog extends StatelessWidget {
  final WorkerJobEntity job;

  const WorkerJobInfoDialog({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final isDone = job.status == WorkerJobStatus.done;
    final typeLabel = job.type == WorkerJobType.cleaning ? 'تنظيف' : 'صيانة';
    final typeIcon = job.type == WorkerJobType.cleaning ? Icons.cleaning_services : Icons.build;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: (job.type == WorkerJobType.cleaning
                            ? AppColors.primaryGreen
                            : AppColors.warningColor)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    typeIcon,
                    color: job.type == WorkerJobType.cleaning
                        ? AppColors.primaryGreen
                        : AppColors.warningColor,
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        typeLabel,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              job.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textDirection: TextDirection.rtl,
            ),
            if (job.address != null) ...[
              SizedBox(height: 12.h),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 18.sp, color: AppColors.primaryGreen),
                  SizedBox(width: 6.w),
                  Text(
                    job.address!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ],
            if (isDone) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColors.successColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'مكتملة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successColor,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
            if (!isDone) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<WorkerJobBloc>()
                        .add(WorkerJobMarkDoneRequested(job.id));
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check_circle, size: 22.sp),
                  label: Text(
                    'تسجيل كمكتملة',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إغلاق',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
