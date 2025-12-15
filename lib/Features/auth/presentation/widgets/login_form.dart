import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/utils/responsive_helper.dart';
import '../../../../core/routing/router_names.dart';

class LoginForm extends StatefulWidget {
  final UserType userType;

  const LoginForm({super.key, required this.userType});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Navigate directly to dashboard based on user type
    switch (widget.userType) {
      case UserType.admin:
        context.go(RouterNames.dashboardAdmin);
        break;
      case UserType.supervisor:
        context.go(RouterNames.dashboardSupervisor);
        break;
      case UserType.worker:
        context.go(RouterNames.dashboardWorker);
        break;
      case UserType.user:
        context.go(RouterNames.dashboardUser);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);
    final padding = isLargeScreen
        ? const EdgeInsets.all(32.0)
        : EdgeInsets.all(24.0.w);
    final spacing16 = ResponsiveHelper.getResponsiveSpacing(context, 16);
    final spacing24 = ResponsiveHelper.getResponsiveSpacing(context, 24);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: AppStrings.username,
            prefixIcon: Icons.person,
            controller: _usernameController,
          ),
          SizedBox(height: spacing16),
          CustomTextField(
            hintText: AppStrings.password,
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword,
            controller: _passwordController,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          SizedBox(height: spacing24),
          CustomButton(text: AppStrings.login, onPressed: _handleLogin),
          SizedBox(height: spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: isLargeScreen ? 100 : 100.w,
                color: Colors.grey.shade300,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 16 : 16.w,
                ),
                child: Text(
                  AppStrings.or,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Container(
                height: 1,
                width: isLargeScreen ? 100 : 100.w,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          SizedBox(height: spacing16),
          if (widget.userType == UserType.supervisor)
            TextButton(
              onPressed: () {
                context.go(RouterNames.companyPasswordManager);
              },
              child: Text(
                AppStrings.registerAsNewManager,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
            )
          else if (widget.userType == UserType.worker)
            TextButton(
              onPressed: () {
                context.go(RouterNames.companyPasswordEmployee);
              },
              child: Text(
                AppStrings.registerAsNewEmployee,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
        ],
      ),
    );
  }
}
