import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';
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
    return Container(
      margin: EdgeInsets.all(20.w),
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
            // Issue Type Dropdown
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedIssueType = value;
                });
              },
              hint: Text(
                'اختر نوع المشكلة',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Location Field
            ReportTextField(
              controller: _locationController,
              label: 'الموقع',
              hint: 'أدخل موقع الحاوية',
              icon: Icons.location_on_outlined,
              maxLines: 1,
            ),
            SizedBox(height: 20.h),

            // Description Field
            ReportTextField(
              controller: _descriptionController,
              label: 'وصف المشكلة',
              hint: 'أدخل وصفاً مفصلاً للمشكلة',
              icon: Icons.description_outlined,
              maxLines: 5,
            ),
            SizedBox(height: 28.h),

            // Submit Button
            ReportSubmitButton(
              onPressed: () => _submitReport(context),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReport(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Show success dialog
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
            'شكراً لك! تم إرسال تقريرك بنجاح وسيتم مراجعته قريباً.',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(RouterNames.home);
              },
              child: Text(
                'حسناً',
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
  }
}

