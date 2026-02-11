import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingRecyclingBinWithItemsIcon extends StatelessWidget {
  const OnboardingRecyclingBinWithItemsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: 40.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.blue.shade700, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        topRight: Radius.circular(4.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'PUSH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '♻',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: -8.w,
              child: Container(
                width: 16.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2.r),
                  border: Border.all(color: Colors.blue.shade400, width: 1),
                ),
                child: Center(
                  child: Text(
                    '♻',
                    style: TextStyle(fontSize: 8.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, color: Colors.green.shade600, size: 12.sp),
            SizedBox(width: 2.w),
            Icon(Icons.eco, color: Colors.green.shade600, size: 12.sp),
          ],
        ),
      ],
    );
  }
}
