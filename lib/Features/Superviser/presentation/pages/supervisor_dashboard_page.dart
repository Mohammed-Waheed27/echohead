import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/routing/router_names.dart';
import '../widgets/supervisor_dashboard_header.dart';
import '../widgets/supervisor_dashboard_content.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterNames.home);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RouterNames.home),
          ),
          title: const Text('لوحة تحكم المشرف', textDirection: TextDirection.rtl),
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
            children: [SupervisorDashboardHeader(), SupervisorDashboardContent()],
          ),
        ),
      ),
    );
  }
}
