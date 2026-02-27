import 'package:flutter/material.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../sections/home_map_section.dart';
import '../sections/home_actions_section.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  static const double _collapsedSize = 0.045;
  static const double _expandedSize = 0.5;

  void _collapseSheet() {
    _sheetController.animateTo(
      _collapsedSize,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _expandSheet() {
    _sheetController.animateTo(
      _expandedSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onMapInteraction() {
    if (_sheetController.size > 0.15) {
      _collapseSheet();
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: HomeMapSection(onMapInteraction: _onMapInteraction),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: _collapsedSize,
              minChildSize: _collapsedSize,
              maxChildSize: _expandedSize,
              snap: true,
              snapSizes: const [0.045, 0.32, 0.5],
              builder: (context, scrollController) {
                return GestureDetector(
                  onTap: () {
                    if (_sheetController.size < 0.12) {
                      _expandSheet();
                    }
                  },
                  child: HomeActionsSection(
                    onCollapse: _collapseSheet,
                    scrollController: scrollController,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
