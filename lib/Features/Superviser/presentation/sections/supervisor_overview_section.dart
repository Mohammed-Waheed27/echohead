import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';

/// Reusable section containing overview stats, chart, and activity list.
class SupervisorOverviewSection extends StatelessWidget {
  const SupervisorOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OverviewStatsGrid(),
          SizedBox(height: 24.h),
          Text(
            'الحاويات الممتلئة (آخر 5 أيام)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 12.h),
          const OverviewChart(),
          SizedBox(height: 24.h),
          Text(
            'آخر النشاطات',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 12.h),
          const ActivityList(),
        ],
      ),
    );
  }
}

class OverviewStatsGrid extends StatelessWidget {
  const OverviewStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OverviewStatCard(
                'إجمالي الحاويات',
                '5',
                Icons.delete_outline,
                AppColors.primaryGreen,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OverviewStatCard(
                'الممتلئة',
                '2',
                Icons.warning_amber_outlined,
                AppColors.warningColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OverviewStatCard(
                'عدد البلاغات',
                '3',
                Icons.report_outlined,
                AppColors.accentTeal,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OverviewStatCard(
                'متوسط الاستجابة',
                '12 د',
                Icons.schedule_outlined,
                AppColors.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OverviewStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const OverviewStatCard(
    this.title,
    this.value,
    this.icon,
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewChart extends StatelessWidget {
  const OverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [2, 1, 2, 0, 1];
    final labels = ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي'];
    final maxVal = data.reduce((a, b) => a > b ? a : b).clamp(1, 10);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (i) {
          final h = (data[i] / maxVal) * 60.h;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28.w,
                height: h.clamp(8.0, 60.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'text': 'أحمد فرغ حاوية زمالك',
        'time': 'منذ 15 دقيقة',
        'icon': Icons.cleaning_services,
      },
      {
        'text': 'بلاغ جديد - حاوية المعادي',
        'time': 'منذ 30 دقيقة',
        'icon': Icons.report,
      },
      {
        'text': 'محمد أكمل مهمة التنظيف',
        'time': 'منذ ساعة',
        'icon': Icons.check_circle,
      },
    ];

    return Column(
      children: activities.map((a) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  a['icon'] as IconData,
                  color: AppColors.primaryGreen,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['text'] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        a['time'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
