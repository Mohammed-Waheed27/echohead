import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../../../../core/routing/router_names.dart';
import '../widgets/action_button.dart';

class HomeActionsSection extends StatelessWidget {
  const HomeActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الخدمات المتاحة',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ActionButton(
                    icon: Icons.near_me_outlined,
                    title: 'أقرب حاوية',
                    subtitle: 'ابحث عن أقرب حاوية',
                    onTap: () => _findNearestTrashCan(context),
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ActionButton(
                    icon: Icons.report_problem_outlined,
                    title: 'الإبلاغ عن مشكلة',
                    subtitle: 'أبلغ عن مشكلة',
                    onTap: () => context.go(RouterNames.reportIssue),
                    color: AppColors.accentTeal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _findNearestTrashCan(BuildContext context) async {
    // Request location permission first
    final hasPermission = await LocationPermissionHandler.requestLocationPermission(context);
    if (!hasPermission) {
      return; // User denied permission or location services disabled
    }

    // Show a simple dialog indicating nearest trash can
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primaryGreen,
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'أقرب حاوية',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: Text(
          'أقرب حاوية نفايات ذكية تقع على بعد 250 متر من موقعك الحالي.',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

