import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/report_status_badge.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../bloc/admin_report_bloc.dart';

class AdminReportDetailsDialog extends StatefulWidget {
  final ReportEntity report;

  const AdminReportDetailsDialog({super.key, required this.report});

  @override
  State<AdminReportDetailsDialog> createState() =>
      _AdminReportDetailsDialogState();
}

class _AdminReportDetailsDialogState extends State<AdminReportDetailsDialog> {
  late ReportStatus _selectedStatus;
  final _adminNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.status;
    _adminNoteController.text = widget.report.adminNote ?? '';
  }

  @override
  void dispose() {
    _adminNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d/M/yyyy - h:mm a', 'ar');

    return BlocListener<AdminReportBloc, AdminReportState>(
      listener: (context, state) {
        if (state is AdminReportActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, ),
              backgroundColor: AppColors.successColor,
            ),
          );
          Navigator.pop(context);
        } else if (state is AdminReportActionFailure) {
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
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    ReportStatusBadge(status: widget.report.status),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInfoRow('المُبلِّغ', widget.report.userName),
                _buildInfoRow(
                  'التاريخ',
                  dateFormat.format(widget.report.createdAt),
                ),
                _buildInfoRow('الخطورة', widget.report.severity.displayName),
                if (widget.report.address != null)
                  _buildInfoRow('الموقع', widget.report.address!),
                if (widget.report.description.isNotEmpty)
                  _buildInfoRow('الوصف', widget.report.description),
                if (widget.report.workerName != null)
                  _buildInfoRow('العامل المسؤول', widget.report.workerName!),
                if (widget.report.workerResponse != null)
                  _buildInfoRow('رد العامل', widget.report.workerResponse!),
                if (_hasImage()) ...[
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildImage(),
                  ),
                ],
                SizedBox(height: 16.h),
                Text(
                  'تحديث الحالة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<ReportStatus>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  items: ReportStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status.displayName,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedStatus = value);
                  },
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _adminNoteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'ملاحظة المدير',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.errorColor,
                        ),
                        label: Text(
                          'حذف',
                          style: TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _updateReport(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.textOnGreen,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'حفظ التحديث',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  void _updateReport(BuildContext context) {
    context.read<AdminReportBloc>().add(
      AdminUpdateReportEvent(
        reportId: widget.report.id,
        status: _selectedStatus,
        adminNote: _adminNoteController.text.trim().isNotEmpty
            ? _adminNoteController.text.trim()
            : null,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', ),
        content: const Text(
          'هل أنت متأكد من حذف هذا البلاغ نهائياً؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminReportBloc>().add(
                AdminDeleteReportEvent(reportId: widget.report.id),
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
