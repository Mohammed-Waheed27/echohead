import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';

class SupervisorProfileLogoutButton extends StatelessWidget {
  const SupervisorProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            context.read<AuthBloc>().add(const LogoutRequested());
            context.go(RouterNames.home);
          },
          icon: Icon(
            Icons.logout,
            color: AppColors.errorColor,
            size: 24.sp,
          ),
          label: Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.errorColor,
            ),
            textDirection: TextDirection.rtl,
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.errorColor),
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
        ),
      ),
    );
  }
}
