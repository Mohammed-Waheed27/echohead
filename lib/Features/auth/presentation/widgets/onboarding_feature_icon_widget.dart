import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class OnboardingFeatureIconWidget extends StatelessWidget {
  final Widget child;

  const OnboardingFeatureIconWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreen,
          width: 2,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: child,
        ),
      ),
    );
  }
}
