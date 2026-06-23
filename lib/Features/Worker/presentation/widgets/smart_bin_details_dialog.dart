import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/domain/entities/smart_bin_realtime_entity.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/smart_bin_status_helper.dart';

class SmartBinDetailsDialog extends StatelessWidget {
  final String title;
  final SmartBinRealtimeEntity bin;
  final bool isLive;

  const SmartBinDetailsDialog({
    super.key,
    required this.title,
    required this.bin,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    final gasPercent = SmartBinStatusHelper.gasPercent(bin.gas);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            if (isLive)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'مباشر',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusChip(label: 'الحالة', value: bin.statusLabel),
              SizedBox(height: 8.h),
              _StatusChip(label: 'نسبة الغاز', value: '$gasPercent%'),
              SizedBox(height: 8.h),
              _StatusChip(
                label: 'خطر الغاز',
                value: bin.gasDanger ? 'نعم' : 'لا',
                valueColor: bin.gasDanger
                    ? AppColors.errorColor
                    : AppColors.primaryGreen,
              ),
              SizedBox(height: 8.h),
              _StatusChip(
                label: 'الجرس',
                value: bin.buzzer ? 'مفعّل' : 'متوقف',
                valueColor: bin.buzzer
                    ? AppColors.errorColor
                    : AppColors.textSecondary,
              ),
              SizedBox(height: 8.h),
              _StatusChip(
                label: 'المسافة',
                value: '${bin.distance.toStringAsFixed(2)} م',
              ),
              if (bin.lastStored != null) ...[
                SizedBox(height: 16.h),
                Text(
                  'آخر قراءة محفوظة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                _LastStoredSection(lastStored: bin.lastStored!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatusChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LastStoredSection extends StatelessWidget {
  final SmartBinLastStored lastStored;

  const _LastStoredSection({required this.lastStored});

  @override
  Widget build(BuildContext context) {
    final gasPercent = SmartBinStatusHelper.gasPercent(lastStored.gas);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _StatusChip(label: 'الغاز', value: '$gasPercent%'),
          SizedBox(height: 6.h),
          _StatusChip(
            label: 'المسافة',
            value: '${lastStored.distance.toStringAsFixed(2)} م',
          ),
          SizedBox(height: 6.h),
          _StatusChip(
            label: 'الجرس',
            value: lastStored.buzzer ? 'مفعّل' : 'متوقف',
          ),
        ],
      ),
    );
  }
}
