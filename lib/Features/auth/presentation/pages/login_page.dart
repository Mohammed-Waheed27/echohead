import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../../../../core/routing/router_names.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  final UserType userType;

  const LoginPage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
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
                        onPressed: () => context.go(RouterNames.home),
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
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: LoginForm(userType: userType),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
