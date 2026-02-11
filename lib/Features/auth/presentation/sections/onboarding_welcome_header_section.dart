import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/widgets/app_logo.dart';

class OnboardingWelcomeHeaderSection extends StatelessWidget {
  const OnboardingWelcomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(
            width: 350.w,
            height: 250.h,
            fit: BoxFit.contain,
            withGlow: false,
          ),
        ],
      ),
    );
  }
}
