import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RescufyLogoAndName extends StatelessWidget {
  const RescufyLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Use theme text style instead of hardcoded
    final textStyle = Theme.of(context).textTheme.displayMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svgs/logo4.svg', height: 50.h, width: 50.w),
        SizedBox(width: 10.w),
        Text('Rescufy', style: textStyle),
      ],
    );
  }
}
