import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          title: const Text(
            'لوحة تحكم المشرف',
            textDirection: TextDirection.rtl,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(RouterNames.profileSupervisor),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SupervisorDashboardHeader(),
              SupervisorDashboardContent(),
            ],
          ),
        ),
      ),
    );
  }
}
