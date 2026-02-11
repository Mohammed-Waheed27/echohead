import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/widgets/app_logo.dart';
import '../../../../core/shared/widgets/onboarding_background_painter.dart';

/// Shared layout for auth pages: full-screen gradient background,
/// white logo in the upper area, and a centered white card for the form.
class AuthGradientLayoutSection extends StatelessWidget {
  /// Content shown inside the centered white card (e.g. login form).
  final Widget child;

  /// Called when the back button is pressed. If null, back button is hidden.
  final VoidCallback? onBackPressed;

  /// Optional custom logo widget. If null, uses default white [AppLogo].
  final Widget? logo;

  const AuthGradientLayoutSection({
    super.key,
    required this.child,
    this.onBackPressed,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: OnboardingBackgroundPainter()),
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Center(
                      child:
                          logo ??
                          AppLogo(
                            width: 350.w,
                            height: 250.h,
                            colorFilter: Colors.white,
                            fit: BoxFit.contain,
                            withGlow: true,
                          ),
                    ),
                    if (onBackPressed != null)
                      Positioned(
                        top: 16.h,
                        right: 16.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: onBackPressed,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 400.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
