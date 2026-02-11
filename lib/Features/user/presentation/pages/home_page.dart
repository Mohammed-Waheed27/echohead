import 'package:flutter/material.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../sections/home_map_section.dart';
import '../sections/home_actions_section.dart';
import '../widgets/hidden_login_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      // appBar: const HomeAppBar(),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Map Section
              Expanded(flex: 2, child: const HomeMapSection()),
              // Actions Section
              Expanded(flex: 1, child: const HomeActionsSection()),
            ],
          ),
          // Hidden login button
          const HiddenLoginButton(),
        ],
      ),
    );
  }
}
