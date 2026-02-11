import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import '../../../../core/shared/widgets/custom_button.dart';
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
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText:
                widget.userType == UserType.worker ||
                    widget.userType == UserType.supervisor
                ? 'اسم المستخدم أو البريد الإلكتروني'
                : AppStrings.username,
            prefixIcon: Icons.person,
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),
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
          SizedBox(height: 24.h),
          CustomButton(text: AppStrings.login, onPressed: _handleLogin),
        ],
      ),
    );
  }
}
