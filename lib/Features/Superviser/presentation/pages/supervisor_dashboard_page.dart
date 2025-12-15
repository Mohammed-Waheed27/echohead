import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../widgets/supervisor_dashboard_header.dart';
import '../widgets/supervisor_dashboard_content.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المشرف', textDirection: TextDirection.rtl),
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
          child: const Column(
            children: [SupervisorDashboardHeader(), SupervisorDashboardContent()],
          ),
        ),
      ),
    );
  }
}
