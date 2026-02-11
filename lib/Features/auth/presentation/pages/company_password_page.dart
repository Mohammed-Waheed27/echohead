import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/routing/router_names.dart';
import '../sections/auth_gradient_layout_section.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthGradientLayoutSection(
        onBackPressed: () => context.pop(),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
    );
  }
}
