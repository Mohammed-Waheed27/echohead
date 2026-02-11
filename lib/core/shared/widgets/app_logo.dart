import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? colorFilter;
  final BoxFit fit;
  final bool withGlow;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.colorFilter,
    this.fit = BoxFit.contain,
    this.withGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(
      'assets/app logo/app main logo.png',
      width: width,
      height: height,
      fit: fit,
      // color: colorFilter,
      colorBlendMode: colorFilter != null ? BlendMode.srcIn : BlendMode.dst,
    );

    if (withGlow) {
      return Container(
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.white.withOpacity(0.5),
          //     blurRadius: 20,
          //     spreadRadius: 5,
          //   ),
          //   BoxShadow(
          //     color: Colors.white.withOpacity(0.3),
          //     blurRadius: 40,
          //     spreadRadius: 10,
          //   ),
          // ],
        ),
        child: logo,
      );
    }

    return logo;
  }
}
