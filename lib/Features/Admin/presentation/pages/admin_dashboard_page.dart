import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../widgets/admin_dashboard_header.dart';
import '../widgets/admin_dashboard_content.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير', textDirection: TextDirection.rtl),
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
