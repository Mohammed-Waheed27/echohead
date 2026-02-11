import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class SupervisorDashboardHeader extends StatelessWidget {
  const SupervisorDashboardHeader({super.key});

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
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بعودتك',
                  style: TextStyle(
                    color: AppColors.textOnGreen,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 6.h),
                Text(
                  'مشرف المنطقة',
                  style: TextStyle(
                    color: AppColors.textOnGreen.withOpacity(0.9),
                    fontSize: 16.sp,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.textOnGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.supervisor_account_outlined,
              color: AppColors.textOnGreen,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
}
