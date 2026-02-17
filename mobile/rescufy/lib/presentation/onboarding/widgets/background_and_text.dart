import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundAndText extends StatelessWidget {
  const BackgroundAndText({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get colors from theme instead of hardcoding
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
      height: 1.4,
    );

    return Stack(
      children: [
        // Centered ambulance image with gradient overlay
        Center(
          child: Container(
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor, backgroundColor.withOpacity(0.0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.1, 0.9],
              ),
            ),
            child: SvgPicture.asset(
              'assets/svgs/ambulance_car_onboarding.svg',
              height: 400.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Text at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Text(
                  'Saving lives is our priority.',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Saving Seconds Saving Lives',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
