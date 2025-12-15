import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../../../../core/routing/router_names.dart';
import '../widgets/login_header.dart';

class CompanyPasswordPage extends StatefulWidget {
  final UserType userType;

  const CompanyPasswordPage({super.key, required this.userType});

  @override
  State<CompanyPasswordPage> createState() => _CompanyPasswordPageState();
}

class _CompanyPasswordPageState extends State<CompanyPasswordPage> {
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          ),
        ),
        child: SafeArea(
          child: isLargeScreen
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              const LoginHeader(),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
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
            child: Padding(
              padding: EdgeInsets.all(24.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    hintText: widget.userType == UserType.supervisor
                        ? AppStrings.companyPasswordForManager
                        : AppStrings.companyPasswordForEmployee,
                    prefixIcon: Icons.lock,
                    obscureText: obscurePassword,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: AppStrings.register,
                    onPressed: () {
                      if (widget.userType == UserType.supervisor) {
                        context.go(RouterNames.dashboardSupervisor);
                      } else {
                        context.go(RouterNames.dashboardWorker);
                      }
                    },
                  ),
                ],
              ),
            ),
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
            const Padding(padding: EdgeInsets.all(32.0), child: LoginHeader()),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: widget.userType == UserType.supervisor
                        ? AppStrings.companyPasswordForManager
                        : AppStrings.companyPasswordForEmployee,
                    prefixIcon: Icons.lock,
                    obscureText: obscurePassword,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: AppStrings.register,
                    onPressed: () {
                      if (widget.userType == UserType.supervisor) {
                        context.go(RouterNames.dashboardSupervisor);
                      } else {
                        context.go(RouterNames.dashboardWorker);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
