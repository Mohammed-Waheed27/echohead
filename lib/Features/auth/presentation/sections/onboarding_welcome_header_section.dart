import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

class OnboardingWelcomeHeaderSection extends StatelessWidget {
  const OnboardingWelcomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App name with glowing effect
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'نظيفة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 56.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: Colors.white.withOpacity(0.6),
                    blurRadius: 40,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: AppColors.primaryGreenLight.withOpacity(0.4),
                    blurRadius: 60,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
