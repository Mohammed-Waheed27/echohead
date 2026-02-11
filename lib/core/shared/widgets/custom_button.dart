import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_can/core/shared/widgets/liquid_glass_container.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Use LiquidGlassButton if no custom background color is provided
    if (backgroundColor == null) {
      return LiquidGlassButton(
        text: text,
        onPressed: onPressed,
        width: width,
        height: height,
        textStyle: textColor != null
            ? TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              )
            : null,
      );
    }

    // Fallback to original implementation for custom colors
    final buttonHeight = height ?? 50.h;
    final fontSize = 16.sp;
    final borderRadius = 12.r;
    final buttonColor = backgroundColor ?? AppColors.primaryGreen;
    final textColorFinal = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width ?? double.infinity,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  buttonColor,
                  buttonColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: onPressed != null
                  ? [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColorFinal,
                fontSize: fontSize,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}
