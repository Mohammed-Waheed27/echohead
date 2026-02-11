import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';

class HiddenLoginButton extends StatelessWidget {
  const HiddenLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: screenHeight * 0.15,
      right: screenWidth * 0.02,
      child: GestureDetector(
        onTap: () => _showLoginOptions(context),
        onLongPress: () => _showLoginOptions(context),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryGreen.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.settings,
            color: AppColors.primaryGreen.withOpacity(0.5),
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  void _showLoginOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 20.h),
                  _buildLoginOption(
                    context,
                    'عامل',
                    Icons.work_outline,
                    RouterNames.loginEmployee,
                  ),
                  SizedBox(height: 12.h),
                  _buildLoginOption(
                    context,
                    'مشرف',
                    Icons.supervisor_account_outlined,
                    RouterNames.loginManager,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOption(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

