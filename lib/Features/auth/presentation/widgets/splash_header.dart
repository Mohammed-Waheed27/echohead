import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/widgets/app_logo.dart';

class SplashHeader extends StatelessWidget {
  const SplashHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(
            width: 200.w,
            height: 120.h,
            colorFilter: Colors.white,
            fit: BoxFit.contain,
            withGlow: true,
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(
                Icons.delete_outline,
                Colors.blue,
              ),
              SizedBox(width: 20.w),
              _buildIcon(
                Icons.public,
                Colors.green,
              ),
              SizedBox(width: 20.w),
              _buildIcon(
                Icons.delete_outline,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 40.sp,
      ),
    );
  }
}
