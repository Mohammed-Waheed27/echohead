import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_status_badge.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../bloc/worker_report_bloc.dart';

class WorkerReportDetailsDialog extends StatefulWidget {
  final ReportEntity report;

  const WorkerReportDetailsDialog({super.key, required this.report});

  @override
  State<WorkerReportDetailsDialog> createState() =>
      _WorkerReportDetailsDialogState();
}

class _WorkerReportDetailsDialogState extends State<WorkerReportDetailsDialog> {
  final _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _responseController.text = widget.report.workerResponse ?? '';
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d/M/yyyy - h:mm a', 'ar');
    final isPending = widget.report.status == ReportStatus.pending;
    final isInProgress = widget.report.status == ReportStatus.inProgress;

    return BlocListener<WorkerReportBloc, WorkerReportState>(
      listener: (context, state) {
        if (state is WorkerReportActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, ),
              backgroundColor: AppColors.successColor,
            ),
          );
          Navigator.pop(context);
        } else if (state is WorkerReportActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, ),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.85.sh, maxWidth: 500.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.report.issueType,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ReportStatusBadge(status: widget.report.status),
                  ],
                ),
                SizedBox(height: 12.h),
                _infoRow('المُبلِّغ', widget.report.userName),
                _infoRow('الخطورة', widget.report.severity.displayName),
                _infoRow('التاريخ', dateFormat.format(widget.report.createdAt)),
                if (widget.report.address != null)
                  _infoRow('الموقع', widget.report.address!),
                if (widget.report.description.isNotEmpty)
                  _infoRow('الوصف', widget.report.description),
                if (widget.report.adminNote != null)
                  _infoRow('ملاحظة المدير', widget.report.adminNote!),
                if (_hasImage()) ...[
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildImage(),
                  ),
                ],
                SizedBox(height: 16.h),
                TextField(
                  controller: _responseController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'ردك على البلاغ',
                    hintText: 'اكتب تفاصيل المعالجة أو الرد للمستخدم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                if (isPending)
                  ElevatedButton.icon(
                    onPressed: () => _takeReport(context),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('استلام البلاغ وبدء المعالجة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.infoColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                if (isInProgress) ...[
                  ElevatedButton.icon(
                    onPressed: () => _respond(context),
                    icon: const Icon(Icons.reply),
                    label: const Text('إرسال الرد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentTeal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton.icon(
                    onPressed: () => _resolve(context),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('تم الحل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(
                    Icons.delete_forever,
                    color: AppColors.errorColor,
                  ),
                  label: Text(
                    'حذف البلاغ مباشرة',
                    style: TextStyle(
                      color: AppColors.errorColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    side: const BorderSide(color: AppColors.errorColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasImage() {
    if (widget.report.imageUrl != null && widget.report.imageUrl!.isNotEmpty) {
      return true;
    }
    return widget.report.imagePath != null &&
        widget.report.imagePath!.isNotEmpty &&
        File(widget.report.imagePath!).existsSync();
  }

  Widget _buildImage() {
    if (widget.report.imageUrl != null && widget.report.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.report.imageUrl!,
        height: 150.h,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(widget.report.imagePath!),
      height: 150.h,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  void _takeReport(BuildContext context) {
    context.read<WorkerReportBloc>().add(
      WorkerTakeReportEvent(reportId: widget.report.id),
    );
  }

  void _respond(BuildContext context) {
    final response = _responseController.text.trim();
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى كتابة رد قبل الإرسال',
          ),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }
    context.read<WorkerReportBloc>().add(
      WorkerRespondReportEvent(reportId: widget.report.id, response: response),
    );
  }

  void _resolve(BuildContext context) {
    context.read<WorkerReportBloc>().add(
      WorkerResolveReportEvent(
        reportId: widget.report.id,
        response: _responseController.text.trim().isNotEmpty
            ? _responseController.text.trim()
            : 'تم حل المشكلة بنجاح',
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', ),
        content: const Text(
          'هل تريد حذف هذا البلاغ مباشرة دون تحديث حالته؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<WorkerReportBloc>().add(
                WorkerDeleteReportEvent(reportId: widget.report.id),
              );
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
