import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../../../../core/shared/widgets/liquid_glass_container.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../widgets/splash_header.dart';
import '../widgets/splash_content.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);

    return Scaffold(
      body: LiquidGlassContainer(
        hasWavyBottom: true,
        wavyDepth: 30.0,
        customColors: AppColors.liquidGlassGradient,
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        child: SafeArea(
          child: isLargeScreen ? _buildDesktopLayout(context) : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: const SplashHeader(),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: const SplashContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return AdaptiveFormContainer(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: SplashHeader(),
            ),
            const Expanded(
              child: SplashContent(),
            ),
          ],
        ),
      ),
    );
  }
}
