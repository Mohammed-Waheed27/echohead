import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/routing/router_names.dart';
import '../sections/report_form_section.dart';
import '../widgets/report_header.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textOnGreen,
            size: 24.sp,
          ),
          onPressed: () => context.go(RouterNames.home),
        ),
        title: Text(
          'الإبلاغ عن مشكلة',
          style: TextStyle(
            color: AppColors.textOnGreen,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ReportHeader(),
            const ReportFormSection(),
          ],
        ),
      ),
    );
  }
}

