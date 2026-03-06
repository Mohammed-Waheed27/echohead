import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../sections/user_home_map_section.dart';
import '../sections/home_actions_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final ValueNotifier<int> _findNearestTrigger = ValueNotifier(0);

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
    _findNearestTrigger.dispose();
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
            child: UserHomeMapSection(
              onMapInteraction: _onMapInteraction,
              findNearestTrigger: _findNearestTrigger,
            ),
          ),
          Positioned.fill(
            child: _HomeDraggableSheet(
              controller: _sheetController,
              collapsedSize: _collapsedSize,
              expandedSize: _expandedSize,
              onCollapse: _collapseSheet,
              onExpand: _expandSheet,
              onFindNearestTrashCan: () => _findNearestTrigger.value++,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeDraggableSheet extends StatefulWidget {
  final DraggableScrollableController controller;
  final double collapsedSize;
  final double expandedSize;
  final VoidCallback onCollapse;
  final VoidCallback onExpand;
  final VoidCallback? onFindNearestTrashCan;

  const _HomeDraggableSheet({
    required this.controller,
    required this.collapsedSize,
    required this.expandedSize,
    required this.onCollapse,
    required this.onExpand,
    this.onFindNearestTrashCan,
  });

  @override
  State<_HomeDraggableSheet> createState() => _HomeDraggableSheetState();
}

class _HomeDraggableSheetState extends State<_HomeDraggableSheet> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isReady = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const SizedBox.shrink();
    }
    return DraggableScrollableSheet(
      key: const ValueKey('home_draggable_sheet'),
      controller: widget.controller,
      initialChildSize: widget.collapsedSize,
      minChildSize: widget.collapsedSize,
      maxChildSize: widget.expandedSize,
      snap: true,
      snapSizes: const [0.045, 0.32, 0.5],
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            if (widget.controller.size < 0.12) {
              widget.onExpand();
            }
          },
          child: HomeActionsSection(
            onCollapse: widget.onCollapse,
            scrollController: scrollController,
            onFindNearestTrashCan: widget.onFindNearestTrashCan,
          ),
        );
      },
    );
  }
}
