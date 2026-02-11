import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../../../../core/routing/router_names.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);
    final padding = isLargeScreen
        ? const EdgeInsets.all(32.0)
        : EdgeInsets.all(24.0.w);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 16);
    final buttonHeight = isLargeScreen ? 60.0 : 60.h;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: AppStrings.registerAsUser,
            onPressed: () {
              context.go(RouterNames.registerUser);
            },
            height: buttonHeight,
          ),
          SizedBox(height: spacing),
          CustomButton(
            text: AppStrings.registerAsEmployee,
            onPressed: () {
              context.go(RouterNames.companyPasswordEmployee);
            },
            height: buttonHeight,
          ),
          SizedBox(height: spacing),
          CustomButton(
            text: AppStrings.registerAsManager,
            onPressed: () {
              context.go(RouterNames.companyPasswordManager);
            },
            height: buttonHeight,
          ),
        ],
      ),
    );
  }
}
