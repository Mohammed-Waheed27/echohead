import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';

/// Header for the home actions modal containing the drag handle,
/// close button, and worker login buttons in the top left.
class HomeModalHeader extends StatelessWidget {
  final VoidCallback onClose;

  const HomeModalHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDragHandle(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              _buildLoginButtons(context),
              // IconButton(
              //   onPressed: onClose,
              //   icon: Icon(
              //     Icons.close,
              //     color: AppColors.textSecondary,
              //     size: 22.sp,
              //   ),
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   visualDensity: VisualDensity.compact,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
      child: Center(
        child: Container(
          width: 36.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LoginChip(
          icon: Icons.work_outline,
          label: 'عامل',
          onTap: () {
            onClose();
            context.go(RouterNames.loginEmployee);
          },
        ),
        SizedBox(width: 8.w),
        _LoginChip(
          icon: Icons.supervisor_account_outlined,
          label: 'مشرف',
          onTap: () {
            onClose();
            context.go(RouterNames.loginManager);
          },
        ),
      ],
    );
  }
}

class _LoginChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LoginChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
