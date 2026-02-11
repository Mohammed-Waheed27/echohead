import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';

class SupervisorDashboardHeader extends StatelessWidget {
  const SupervisorDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      hasWavyBottom: true,
      wavyDepth: 20.0,
      customColors: AppColors.liquidGlassGradient,
      gradientBegin: Alignment.topRight,
      gradientEnd: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
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
