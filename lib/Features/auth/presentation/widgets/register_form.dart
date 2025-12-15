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

class RegisterForm extends StatefulWidget {
  final UserType userType;

  const RegisterForm({
    super.key,
    required this.userType,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
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
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 14);

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            CustomTextField(
              hintText: AppStrings.userName,
              prefixIcon: Icons.person,
              controller: _usernameController,
            ),
            SizedBox(height: spacing16),
            CustomTextField(
              hintText: AppStrings.enterPassword,
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
            SizedBox(height: spacing16),
            CustomTextField(
              hintText: AppStrings.confirmPassword,
              prefixIcon: Icons.lock,
              obscureText: _obscureConfirmPassword,
              controller: _confirmPasswordController,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            SizedBox(height: spacing16),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: AppColors.primaryGreen,
                ),
                Expanded(
                  child: Text(
                    AppStrings.agreeToPermissions,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: fontSize,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing24),
            CustomButton(
              text: AppStrings.register,
              onPressed: _handleRegister,
            ),
          ],
        ),
      ),
    );
  }
}

