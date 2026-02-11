import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenDark,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.report_problem_outlined,
            color: AppColors.textOnGreen,
            size: 56.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'ساعدنا في تحسين الخدمة',
            style: TextStyle(
              color: AppColors.textOnGreen,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'أبلغنا عن أي مشكلة تواجهها مع حاويات النفايات الذكية',
            style: TextStyle(
              color: AppColors.textOnGreen.withOpacity(0.9),
              fontSize: 14.sp,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

