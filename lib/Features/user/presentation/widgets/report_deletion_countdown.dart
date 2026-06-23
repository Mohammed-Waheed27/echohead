import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../user/domain/entities/report_entity.dart';

class ReportDeletionCountdown extends StatefulWidget {
  final ReportEntity report;

  const ReportDeletionCountdown({super.key, required this.report});

  @override
  State<ReportDeletionCountdown> createState() =>
      _ReportDeletionCountdownState();
}

class _ReportDeletionCountdownState extends State<ReportDeletionCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.report.isResolved && widget.report.scheduledDeleteAt != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String? _countdownText() {
    if (!widget.report.isResolved || widget.report.scheduledDeleteAt == null) {
      return null;
    }
    final remaining = widget.report.timeUntilDeletion;
    if (remaining == null || remaining == Duration.zero) {
      return 'سيتم الحذف قريباً';
    }
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return 'يُحذف خلال ${minutes}د ${seconds}ث';
  }

  @override
  Widget build(BuildContext context) {
    final text = _countdownText();
    if (text == null) return const SizedBox.shrink();

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.successColor),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.successColor,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
