import 'package:flutter/material.dart';

class AppColors {
  // Primary Green Colors - Vibrant greens from reference images
  static const Color primaryGreen = Color(0xFF4CAF50); // Vibrant lime green
  static const Color primaryGreenLight = Color(
    0xFF66BB6A,
  ); // Bright medium green
  static const Color primaryGreenDark = Color(
    0xFF388E3C,
  ); // Deeper emerald green
  static const Color primaryGreenAccent = Color(
    0xFF81C784,
  ); // Light accent green

  // Liquid Glass Gradient Colors - For organic shapes and gradients
  static const Color liquidGlassLight = Color(
    0xFFA5D6A7,
  ); // Very light green for glass effect
  static const Color liquidGlassMedium = Color(
    0xFF81C784,
  ); // Medium light for layering
  static const Color liquidGlassBase = Color(0xFF66BB6A); // Base vibrant green
  static const Color liquidGlassDark = Color(0xFF4CAF50); // Darker layer
  static const Color liquidGlassDarker = Color(0xFF388E3C); // Deepest layer

  // Secondary Green Colors - Matching palette
  static const Color secondaryGreen = Color(0xFF81C784); // Light green
  static const Color secondaryGreenLight = Color(
    0xFFA5D6A7,
  ); // Very light green
  static const Color secondaryGreenDark = Color(
    0xFF388E3C,
  ); // Medium dark green

  // Gradient Colors - Updated for liquid glass effect
  static const Color gradientGreenStart = Color(0xFF66BB6A); // Bright start
  static const Color gradientGreenMiddle = Color(0xFF4CAF50); // Vibrant middle
  static const Color gradientGreenEnd = Color(0xFF388E3C); // Deep end
  static const Color gradientGreenLight = Color(0xFFA5D6A7); // Light accent

  // Accent Colors - Complementary colors
  static const Color accentTeal = Color(0xFF26A69A); // Teal accent
  static const Color accentEmerald = Color(0xFF00C853); // Emerald accent

  // Background Colors
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Light gray background
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textOnGreen = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF5F5F5);

  // Icon Colors
  static const Color iconColor = Color(0xFF424242);
  static const Color iconGreen = Color(0xFF4CAF50);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color infoColor = Color(0xFF2196F3);

  // Liquid Glass Gradient - Main gradient for backgrounds
  static List<Color> get liquidGlassGradient => [
    liquidGlassBase,
    liquidGlassDark,
    liquidGlassDarker,
  ];

  // Liquid Glass Gradient - Horizontal (left to right)
  static List<Color> get liquidGlassGradientHorizontal => [
    liquidGlassLight,
    liquidGlassBase,
    liquidGlassDark,
  ];

  // Liquid Glass Gradient - Vertical (top to bottom)
  static List<Color> get liquidGlassGradientVertical => [
    liquidGlassBase,
    liquidGlassDark,
    liquidGlassDarker,
  ];
}
