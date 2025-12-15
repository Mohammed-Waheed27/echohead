import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A container that adapts to different screen sizes
/// Centers content on large screens with max width constraint
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? maxWidth;
  final bool centerContent;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.maxWidth,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveHelper.isLargeScreen(context);
    final contentMaxWidth = maxWidth ?? ResponsiveHelper.getMaxContentWidth(context);
    final adaptivePadding = padding ?? ResponsiveHelper.getAdaptivePadding(
      context,
      maxWidth: contentMaxWidth,
    );

    Widget content = child;

    // Apply padding
    if (adaptivePadding != EdgeInsets.zero) {
      content = Padding(
        padding: adaptivePadding,
        child: child,
      );
    }

    // For large screens, center the content with max width
    if (isLargeScreen && contentMaxWidth != null && centerContent) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth),
          child: Padding(
            padding: adaptivePadding,
            child: child,
          ),
        ),
      );
    }

    if (color != null) {
      return Container(
        color: color,
        child: content,
      );
    }

    return content;
  }
}

/// Container for forms - smaller max width
class AdaptiveFormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const AdaptiveFormContainer({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveContainer(
      maxWidth: ResponsiveHelper.maxFormWidth,
      padding: padding,
      color: color,
      child: child,
    );
  }
}
