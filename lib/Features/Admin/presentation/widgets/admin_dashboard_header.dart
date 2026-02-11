import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return LiquidGlassContainer(
      hasWavyBottom: true,
      wavyDepth: 20.0,
      customColors: AppColors.liquidGlassGradientHorizontal,
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.topRight,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.welcomeBack,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
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
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          Text(
            'مدير النظام',
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
