import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/routing/router_names.dart';
import '../sections/auth_gradient_layout_section.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  final UserType userType;

  const LoginPage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthGradientLayoutSection(
        onBackPressed: () => context.go(RouterNames.home),
        child: LoginForm(userType: userType),
      ),
    );
  }
}
