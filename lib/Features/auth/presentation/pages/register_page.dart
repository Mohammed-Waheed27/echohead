import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../sections/auth_gradient_layout_section.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  final UserType userType;

  const RegisterPage({
    super.key,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthGradientLayoutSection(
        onBackPressed: () => context.pop(),
        child: RegisterForm(userType: userType),
      ),
    );
  }
}
