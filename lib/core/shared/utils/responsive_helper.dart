import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1920;

  // Max content width for large screens
  static const double maxContentWidth = 1200;
  static const double maxContentWidthLarge = 1400;
  static const double maxFormWidth = 500;

  // Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Check if mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  // Check if tablet
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // Check if desktop
  static bool isDesktop(BuildContext context) {
    final width = screenWidth(context);
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  // Check if large desktop
  static bool isLargeDesktop(BuildContext context) {
    return screenWidth(context) >= desktopBreakpoint;
  }

  // Check if screen is large (desktop or large desktop)
  static bool isLargeScreen(BuildContext context) {
    return isDesktop(context) || isLargeDesktop(context);
  }

  // Get responsive padding - uses pixels for desktop, ScreenUtil for mobile
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = screenWidth(context);
    
    if (width < mobileBreakpoint) {
      // Mobile: Use fixed padding
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else if (width < tabletBreakpoint) {
      // Tablet: Medium padding
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    } else if (width < desktopBreakpoint) {
      // Desktop: Larger padding
      return const EdgeInsets.symmetric(horizontal: 60, vertical: 24);
    } else {
      // Large Desktop: Maximum padding
      return const EdgeInsets.symmetric(horizontal: 80, vertical: 32);
    }
  }

  // Get adaptive padding for centered content on large screens
  static EdgeInsets getAdaptivePadding(BuildContext context, {double? maxWidth}) {
    final width = screenWidth(context);
    final contentMaxWidth = maxWidth ?? maxContentWidth;
    
    if (width >= desktopBreakpoint) {
      // For large screens, calculate padding to center content
      final horizontalPadding = (width - contentMaxWidth) / 2;
      
      return EdgeInsets.symmetric(
        horizontal: horizontalPadding > 80 ? horizontalPadding : 80,
        vertical: 32,
      );
    } else if (width >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 60, vertical: 24);
    } else if (width >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    
    if (width >= largeDesktopBreakpoint) {
      return baseSize * 1.2;
    } else if (width >= desktopBreakpoint) {
      return baseSize * 1.1;
    } else if (width >= tabletBreakpoint) {
      return baseSize;
    } else {
      return baseSize * 0.95;
    }
  }

  // Get max width constraint for content
  static double? getMaxContentWidth(BuildContext context, {double? customMaxWidth}) {
    final width = screenWidth(context);
    final maxWidth = customMaxWidth ?? maxContentWidth;
    
    if (width >= largeDesktopBreakpoint) {
      return customMaxWidth ?? maxContentWidthLarge;
    } else if (width >= desktopBreakpoint) {
      return maxWidth;
    }
    return null; // No constraint for smaller screens
  }

  // Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final width = screenWidth(context);
    
    if (width >= desktopBreakpoint) {
      return baseSpacing * 1.5;
    } else if (width >= tabletBreakpoint) {
      return baseSpacing;
    } else {
      return baseSpacing * 0.9;
    }
  }

  // Get responsive border radius
  static double getResponsiveRadius(BuildContext context, double baseRadius) {
    final width = screenWidth(context);
    
    if (width >= desktopBreakpoint) {
      return baseRadius * 1.2;
    }
    return baseRadius;
  }
}
