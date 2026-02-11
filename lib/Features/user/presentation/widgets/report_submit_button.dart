import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_can/core/shared/widgets/liquid_glass_container.dart';
import '../../../../core/shared/constants/app_colors.dart';

class ReportSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportSubmitButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassButton(
      text: 'إرسال التقرير',
      onPressed: onPressed,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      customColors: AppColors.liquidGlassGradient,
      textStyle: TextStyle(
        color: AppColors.textOnGreen,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
