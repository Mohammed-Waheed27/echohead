import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/widgets/app_logo.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Center(
        child: AppLogo(
          width: 180.w,
          height: 100.h,
          colorFilter: Colors.white,
          fit: BoxFit.contain,
          withGlow: true,
        ),
      ),
    );
  }
}
