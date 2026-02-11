import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/app_logo.dart';

/// App bar for the home page: gradient header with logo and "SWMS" branding.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _headerHeight = 72.0;

  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: _headerHeight.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: AppColors.liquidGlassGradientHorizontal,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLogo(
                  width: 48.w,
                  height: 48.w,
                  colorFilter: Colors.white,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 12.w),
                // Text(
                //   'SWMS',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 24.sp,
                //     fontWeight: FontWeight.bold,
                //     letterSpacing: 1.2,
                //     shadows: [
                //       Shadow(
                //         color: Colors.black.withOpacity(0.2),
                //         blurRadius: 4,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_headerHeight.h);
}
