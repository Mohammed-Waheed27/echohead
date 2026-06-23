import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';
import '../../domain/entities/report_entity.dart';
import '../bloc/report_bloc.dart';
import '../widgets/report_image_picker.dart';
import '../widgets/report_location_field.dart';
import '../widgets/report_severity_selector.dart';
import '../widgets/report_text_field.dart';
import '../widgets/report_submit_button.dart';

class ReportFormSection extends StatefulWidget {
  const ReportFormSection({super.key});

  @override
  State<ReportFormSection> createState() => _ReportFormSectionState();
}

class _ReportFormSectionState extends State<ReportFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _issueTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedIssueType;
  ReportSeverity? _selectedSeverity;
  String? _imagePath;
  double? _latitude;
  double? _longitude;

  final List<String> _issueTypes = [
    'حاوية ممتلئة',
    'حاوية تالفة',
    'حاوية غير موجودة',
    'رائحة كريهة',
    'مشكلة أخرى',
  ];

  @override
  void dispose() {
    _issueTypeController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSubmitSuccess) {
          _showSuccessDialog(context);
        } else if (state is ReportSubmitFailure) {
          _showSubmitErrorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ReportSubmitting;

        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.borderColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildIssueTypeDropdown(),
                SizedBox(height: 20.h),

                ReportSeveritySelector(
                  selectedSeverity: _selectedSeverity,
                  onChanged: (v) => setState(() => _selectedSeverity = v),
                ),
                SizedBox(height: 20.h),

                ReportLocationField(
                  controller: _locationController,
                  onCoordinatesObtained: (coords) {
                    if (coords != null) {
                      setState(() {
                        _latitude = coords.$1;
                        _longitude = coords.$2;
                      });
                    }
                  },
                ),
                SizedBox(height: 20.h),

                ReportTextField(
                  controller: _descriptionController,
                  label: 'وصف المشكلة',
                  hint: 'أدخل وصفاً مفصلاً للمشكلة',
                  icon: Icons.description_outlined,
                  maxLines: 5,
                ),
                SizedBox(height: 20.h),

                ReportImagePicker(
                  imagePath: _imagePath,
                  onImagePicked: (path) => setState(() => _imagePath = path),
                ),
                SizedBox(height: 28.h),

                ReportSubmitButton(
                  onPressed: isSubmitting
                      ? () {}
                      : () => _submitReport(context),
                  isLoading: isSubmitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIssueTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المشكلة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 10.h),
        DropdownButtonFormField<String>(
          value: _selectedIssueType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          items: _issueTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() => _selectedIssueType = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          hint: Text(
            'اختر نوع المشكلة',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  void _submitReport(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSeverity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار درجة خطورة البلاغ',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }

    context.read<ReportBloc>().add(
      SubmitReportEvent(
        issueType: _selectedIssueType!,
        description: _descriptionController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        address: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        imagePath: _imagePath,
        severity: _selectedSeverity!,
      ),
    );
  }

  void _showSubmitErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: AppColors.errorColor,
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'فشل إرسال البلاغ',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _submitReport(context);
            },
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.successColor,
              size: 32.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'تم الإرسال',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: Text(
          'شكراً لك! تم إرسال تقريرك بنجاح وسيتم مراجعته قريباً. يمكنك متابعة حالة تقاريرك من سجل البلاغات.',
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouterNames.reportIssue);
            },
            child: Text(
              'إرسال بلاغ آخر',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouterNames.reportHistory);
            },
            child: Text(
              'عرض سجل البلاغات',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouterNames.home);
            },
            child: Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.primaryGreen, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
