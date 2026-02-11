import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      hasWavyBottom: true,
      wavyDepth: 20.0,
      customColors: AppColors.liquidGlassGradient,
      gradientBegin: Alignment.topRight,
      gradientEnd: Alignment.bottomLeft,
      padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.report_problem_outlined,
            color: AppColors.textOnGreen,
            size: 56.sp,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'ساعدنا في تحسين الخدمة',
            style: TextStyle(
              color: AppColors.textOnGreen,
              fontSize: 22.sp,
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
