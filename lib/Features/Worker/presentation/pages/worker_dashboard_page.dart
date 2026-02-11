import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../widgets/worker_dashboard_header.dart';
import '../widgets/worker_dashboard_content.dart';

class WorkerDashboardPage extends StatelessWidget {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterNames.home);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RouterNames.home),
          ),
          title: const Text(
            'لوحة تحكم العامل',
            textDirection: TextDirection.rtl,
          ),
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
                context.go(RouterNames.home);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [WorkerDashboardHeader(), WorkerDashboardContent()],
          ),
        ),
      ),
    );
  }
}
