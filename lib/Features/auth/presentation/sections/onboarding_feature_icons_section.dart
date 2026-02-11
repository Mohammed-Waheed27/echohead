import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingFeatureIconsSection extends StatelessWidget {
  const OnboardingFeatureIconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Image.asset(
          'assets/app images/welcom screen logo.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: 200.h,
        ),
      ),
    );
  }
}
