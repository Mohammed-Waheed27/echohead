import 'package:flutter/material.dart';
import '../sections/auth_gradient_layout_section.dart';
import '../widgets/forgot_password_form.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthGradientLayoutSection(
        onBackPressed: () => context.pop(),
        child: const ForgotPasswordForm(),
      ),
    );
  }
}
