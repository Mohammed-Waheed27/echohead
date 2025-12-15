import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/shared/widgets/adaptive_container.dart';
import '../widgets/user_dashboard_header.dart';
import '../widgets/user_dashboard_content.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم المستخدم',
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
            children: [UserDashboardHeader(), UserDashboardContent()],
          ),
        ),
      ),
    );
  }
}
