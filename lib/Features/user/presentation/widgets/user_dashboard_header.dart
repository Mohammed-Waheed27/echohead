import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';

class UserDashboardHeader extends StatelessWidget {
  const UserDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      hasWavyBottom: true,
      wavyDepth: 20.0,
      customColors: AppColors.liquidGlassGradientHorizontal,
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.topRight,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.welcomeBack,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 8.h),
          Text(
            'مستخدم',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
