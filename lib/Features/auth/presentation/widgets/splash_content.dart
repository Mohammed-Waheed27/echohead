import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../../../../core/routing/router_names.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);
    final padding = isLargeScreen 
        ? const EdgeInsets.all(32.0) 
        : EdgeInsets.all(24.0.w);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 20);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 12);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: AppStrings.letsStart,
            onPressed: () {
              context.go(RouterNames.welcome);
            },
            backgroundColor: AppColors.primaryGreen,
          ),
          SizedBox(height: spacing),
          Text(
            'هذا البرنامج تم تصميمه تحت إشراف الدكتوره هالة الحديدي',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}

