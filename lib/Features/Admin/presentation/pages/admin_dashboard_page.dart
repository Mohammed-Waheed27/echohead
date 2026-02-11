import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../widgets/admin_dashboard_header.dart';
import '../widgets/admin_dashboard_content.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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
        title: const Text('لوحة تحكم المدير', textDirection: TextDirection.rtl),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
              context.go(RouterNames.splash);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AdaptiveContainer(
          centerContent: true,
          child: const Column(
            children: [AdminDashboardHeader(), AdminDashboardContent()],
          ),
        ),
      ),
    );
  }
}
