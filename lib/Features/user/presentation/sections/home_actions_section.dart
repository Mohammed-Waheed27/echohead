import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/location_permission_handler.dart';
import '../../../../core/routing/router_names.dart';
import '../widgets/compact_action_button.dart';
import '../widgets/home_modal_header.dart';

/// Content displayed inside the home actions draggable modal.
class HomeActionsSection extends StatelessWidget {
  final VoidCallback onCollapse;
  final ScrollController? scrollController;

  const HomeActionsSection({
    super.key,
    required this.onCollapse,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.h),
        children: [
          HomeModalHeader(onClose: onCollapse),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'الخدمات المتاحة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CompactActionButton(
                        icon: Icons.near_me_outlined,
                        title: 'أقرب حاوية',
                        subtitle: 'ابحث عن أقرب حاوية',
                        onTap: () => _findNearestTrashCan(context),
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CompactActionButton(
                        icon: Icons.report_problem_outlined,
                        title: 'الإبلاغ عن مشكلة',
                        subtitle: 'أبلغ عن مشكلة',
                        onTap: () => context.go(RouterNames.reportIssue),
                        color: AppColors.accentTeal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _findNearestTrashCan(BuildContext context) async {
    final hasPermission =
        await LocationPermissionHandler.requestLocationPermission(context);
    if (!hasPermission) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: AppColors.primaryGreen, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'أقرب حاوية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: Text(
          'أقرب حاوية نفايات ذكية تقع على بعد 250 متر من موقعك الحالي.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
