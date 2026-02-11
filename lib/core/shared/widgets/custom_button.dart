import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              color: buttonColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: onPressed != null
                  ? [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
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
