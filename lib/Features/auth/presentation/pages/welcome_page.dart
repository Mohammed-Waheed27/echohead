import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../widgets/welcome_header.dart';
import '../widgets/welcome_buttons.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);

    return Scaffold(
      body: LiquidGlassContainer(
        hasWavyBottom: false,
        customColors: AppColors.liquidGlassGradientVertical,
        gradientBegin: Alignment.topCenter,
        gradientEnd: Alignment.bottomCenter,
        child: SafeArea(
          child: isLargeScreen
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          const Expanded(flex: 2, child: WelcomeHeader()),
          const Expanded(flex: 3, child: WelcomeButtons()),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500.w),
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            const Expanded(flex: 2, child: WelcomeHeader()),
            const Expanded(flex: 3, child: WelcomeButtons()),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
