import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trash_can/core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/routing/router_names.dart';
import '../bloc/auth_bloc.dart';

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
  String? _usernameError;
  String? _passwordError;

  bool get _isWorkerOrSupervisor =>
      widget.userType == UserType.worker ||
      widget.userType == UserType.supervisor;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? AppStrings.fieldRequired : null;
      _passwordError = password.isEmpty ? AppStrings.fieldRequired : null;
    });

    if (username.isEmpty || password.isEmpty) return;

    if (_isWorkerOrSupervisor) {
      context.read<AuthBloc>().add(
        LoginRequested(
          username: username,
          password: password,
          userType: widget.userType,
        ),
      );
      return;
    }

    switch (widget.userType) {
      case UserType.admin:
        context.go(RouterNames.dashboardAdmin);
        break;
      case UserType.user:
        context.go(RouterNames.dashboardUser);
        break;
      default:
        break;
    }
  }

  void _handleForgotPassword() {
    context.push(RouterNames.forgotPassword);
  }

  String? _extractErrorMessage(String rawMessage) {
    if (rawMessage.startsWith('Exception: ')) {
      return rawMessage.replaceFirst('Exception: ', '');
    }
    return rawMessage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (widget.userType == UserType.worker) {
            context.go(RouterNames.dashboardWorker);
          } else if (widget.userType == UserType.supervisor) {
            context.go(RouterNames.dashboardSupervisor);
          }
        } else if (state is AuthError) {
          setState(() {
            _usernameError = _extractErrorMessage(state.message);
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isWorkerOrSupervisor) ...[
                Text(
                  widget.userType == UserType.worker
                      ? 'لمتابعة الحاويات وتنفيذ المهام'
                      : 'لمراقبة النظام وتحليل البيانات',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              CustomTextField(
                hintText:
                    widget.userType == UserType.worker ||
                        widget.userType == UserType.supervisor
                    ? 'اسم المستخدم أو البريد الإلكتروني'
                    : AppStrings.username,
                prefixIcon: Icons.person,
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                errorText: _usernameError,
                onChanged: (_) => setState(() => _usernameError = null),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                hintText: AppStrings.password,
                prefixIcon: Icons.lock,
                obscureText: _obscurePassword,
                controller: _passwordController,
                errorText: _passwordError,
                onChanged: (_) => setState(() => _passwordError = null),
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
              if (_isWorkerOrSupervisor) ...[
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              CustomButton(
                text: AppStrings.login,
                onPressed: isLoading ? null : _handleLogin,
              ),
            ],
          ),
        );
      },
    );
  }
}
