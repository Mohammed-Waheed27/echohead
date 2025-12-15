import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../widgets/worker_dashboard_header.dart';
import '../widgets/worker_dashboard_content.dart';

class WorkerDashboardPage extends StatelessWidget {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم العامل',
          textDirection: TextDirection.rtl,
        ),
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
            children: [
              WorkerDashboardHeader(),
              WorkerDashboardContent(),
            ],
          ),
        ),
      ),
    );
  }
}

