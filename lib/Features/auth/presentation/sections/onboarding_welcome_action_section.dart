import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/utils/first_launch_handler.dart';

class OnboardingWelcomeActionSection extends StatelessWidget {
  const OnboardingWelcomeActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Let's Start Button - Using white background with green text (as per design)
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () async {
              // Mark first launch as complete
              await FirstLaunchHandler.setFirstLaunchComplete();
              // Navigate directly to home page (map page)
              if (context.mounted) {
                context.go(RouterNames.home);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              AppStrings.letsStart,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        // Footer text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            'هذا البرنامج تم تصميمه تحت إشراف الدكتوره هالة الحديدي',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}
