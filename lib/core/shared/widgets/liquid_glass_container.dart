import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import 'liquid_glass_gradient_decoration.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final bool hasWavyBottom;
  final double wavyDepth;
  final List<Color>? customColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.hasWavyBottom = false,
    this.wavyDepth = 20.0,
    this.customColors,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: LiquidGlassGradientDecoration(
        hasWavyBottom: hasWavyBottom,
        wavyDepth: wavyDepth.h,
        customColors: customColors,
        begin: gradientBegin,
        end: gradientEnd,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// Liquid Glass Button - Reusable button with liquid glass effect
class LiquidGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final List<Color>? customColors;
  final bool isFullWidth;

  const LiquidGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.customColors,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: isFullWidth ? double.infinity : width,
          height: height ?? 50.h,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: customColors ?? AppColors.liquidGlassGradient,
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: (customColors?.first ?? AppColors.primaryGreen)
                    .withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: (customColors?.last ?? AppColors.primaryGreenDark)
                    .withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style:
                  textStyle ??
                  TextStyle(
                    color: AppColors.textOnGreen,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
