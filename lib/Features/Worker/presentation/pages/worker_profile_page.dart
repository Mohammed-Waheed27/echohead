import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../widgets/worker_profile_header.dart';
import '../widgets/worker_profile_info_card.dart';
import '../widgets/worker_profile_logout_button.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'الملف الشخصي',
          textDirection: TextDirection.rtl,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkerProfileHeader(
              displayName: 'عامل',
              userType: UserType.worker,
            ),
            WorkerProfileInfoCard(
              username: 'عامل',
              email: 'worker@example.com',
            ),
            const WorkerProfileLogoutButton(),
          ],
        ),
      ),
    );
  }
}
