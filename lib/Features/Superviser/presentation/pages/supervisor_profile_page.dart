import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/constants/user_types.dart';
import '../widgets/supervisor_profile_header.dart';
import '../widgets/supervisor_profile_info_card.dart';
import '../widgets/supervisor_profile_logout_button.dart';

class SupervisorProfilePage extends StatelessWidget {
  const SupervisorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
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
            SupervisorProfileHeader(
              displayName: 'مشرف',
              userType: UserType.supervisor,
            ),
            SupervisorProfileInfoCard(
              username: 'مشرف',
              email: 'supervisor@example.com',
            ),
            const SupervisorProfileLogoutButton(),
          ],
        ),
      ),
    );
  }
}
